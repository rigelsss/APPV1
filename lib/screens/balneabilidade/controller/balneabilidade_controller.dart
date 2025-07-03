import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';
import 'package:sudema_app/models/praia_marker.dart';
import 'package:sudema_app/services/marcadores_service.dart';
import 'package:sudema_app/services/mapa_service.dart';
import 'package:sudema_app/screens/balneabilidade/services/balneabilidade_service.dart';
import 'package:sudema_app/screens/balneabilidade/services/icones_service.dart';
import 'package:sudema_app/screens/balneabilidade/services/filtros_service.dart';
import 'package:sudema_app/screens/balneabilidade/services/localizacao_service.dart';
import 'package:sudema_app/screens/balneabilidade/filtros_constants.dart';


class ClassificacaoLabels {
  static const todas = 'Mostrar tudo';
  static const proprias = 'Mostrar apenas próprias';
  static const improprias = 'Mostrar apenas impróprias';
}

class BalneabilidadeController extends ChangeNotifier {
  late GoogleMapController mapController;
  final GlobalKey mapKey = GlobalKey();

  LatLng? posicaoAtualUsuario;
  Marker? marcadorUsuario;
  BitmapDescriptor? iconeUsuario;

  List<EstacaoMonitoramento> estacoes = [];
  bool isLoadingEstacoes = true;

  List<String> classificacoesSelecionadas = ['Próprias', 'Impróprias'];
  String municipioSelecionado = '';
  String praiaSelecionada = '';
  String trechoSelecionado = '';

  double currentZoom = 14.0;
  final double minZoomToShowMarkers = 12.5;

  BitmapDescriptor? iconePropria;
  BitmapDescriptor? iconeImpropria;

  final List<PraiaMarker> todosMarcadores = [];
  final Set<Marker> marcadoresVisiveis = {};

  EstacaoMonitoramento? estacaoSelecionada;
  Offset? overlayPosition;

  bool mapaCriado = false;

  Future<void> inicializar() async {
    await _carregarIcones();
    await _carregarEstacoesDaAPI();
    await centralizarNaLocalizacaoAtual();
    if (mapaCriado) gerarMarcadoresComSimulacao();
  }

  Future<void> _carregarIcones() async {
    try {
      iconePropria = await IconesService.carregarIconePropria();
      iconeImpropria = await IconesService.carregarIconeImpropria();
      iconeUsuario = await IconesService.carregarIconeUsuario();
    } catch (e) {
      throw Exception('Erro ao carregar ícones: $e');
    }
  }

  Future<void> centralizarNaLocalizacaoAtual() async {
    final localizacao = await LocalizacaoService.obterLocalizacaoAtual();
    if (localizacao == null) return;

    posicaoAtualUsuario = localizacao;
    marcadorUsuario = Marker(
      markerId: const MarkerId('usuario'),
      position: localizacao,
      icon: iconeUsuario ?? BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(title: 'Sua localização'),
    );

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: localizacao, zoom: 14.5),
      ),
    );

    notifyListeners();
  }

  Future<void> _carregarEstacoesDaAPI() async {
    try {
      estacoes = await BalneabilidadeService.carregarEstacoes();
    } on ApiException catch (e) {
      print('Erro API: ${e.message}');
    } finally {
      isLoadingEstacoes = false;
      notifyListeners();
    }
  }

  void limparSelecaoEstacao() {
    estacaoSelecionada = null;
    overlayPosition = null;
    notifyListeners();
  }

  void gerarMarcadoresComSimulacao() {
    todosMarcadores.clear();

    final novosMarcadores = MarcadoresService.gerarMarcadores(
      estacoes: estacoes,
      iconePropria: iconePropria ?? BitmapDescriptor.defaultMarker,
      iconeImpropria: iconeImpropria ?? BitmapDescriptor.defaultMarker,
      getScreenCoordinate: mapController.getScreenCoordinate,
      getMapOffset: () {
        final RenderBox box = mapKey.currentContext!.findRenderObject() as RenderBox;
        return box.localToGlobal(Offset.zero);
      },
      onTapEstacao: (est, offset) {
        estacaoSelecionada = est;
        overlayPosition = offset;
        notifyListeners();
      },
    );

    todosMarcadores.addAll(novosMarcadores);
    filtrarMarcadores();
  }

  void filtrarMarcadores() {
    marcadoresVisiveis.clear();
    marcadoresVisiveis.addAll(
      FiltrosService.filtrar(
        todosMarcadores: todosMarcadores,
        estacoes: estacoes,
        municipioSelecionado: municipioSelecionado,
        trechoSelecionado: trechoSelecionado,
        classificacoesSelecionadas: classificacoesSelecionadas,
        currentZoom: currentZoom,
        minZoomToShowMarkers: minZoomToShowMarkers,
      ),
    );
    notifyListeners();
  }

  void resetarFiltros() {
    municipioSelecionado = '';
    praiaSelecionada = '';
    trechoSelecionado = '';
  }

  void toggleClassificacao(String item) async {
    if (item == ClassificacaoLabels.todas) {
      classificacoesSelecionadas = ['Próprias', 'Impróprias'];
    } else if (item == ClassificacaoLabels.proprias) {
      classificacoesSelecionadas = ['Próprias'];
    } else if (item == ClassificacaoLabels.improprias) {
      classificacoesSelecionadas = ['Impróprias'];
    }

    resetarFiltros();

    if (posicaoAtualUsuario != null) {
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: posicaoAtualUsuario!, zoom: 14.5),
        ),
      );
    }

    filtrarMarcadores();
  }

  String getClassificacaoLabel() {
    return classificacoesSelecionadas.length == 2
        ? ClassificacaoLabels.todas
        : classificacoesSelecionadas.contains('Próprias')
            ? ClassificacaoLabels.proprias
            : ClassificacaoLabels.improprias;
  }

  void alterarMunicipio(String novoMunicipio, VoidCallback onMarcadoresAtualizados) {
    municipioSelecionado = novoMunicipio;
    trechoSelecionado = '';
    praiaSelecionada = '';
    notifyListeners();

    if (novoMunicipio.isNotEmpty && novoMunicipio != 'Todos') {
      MapaService.moverMapaParaMunicipio(
        controller: mapController,
        estacoes: estacoes,
        municipio: novoMunicipio,
        onComplete: onMarcadoresAtualizados,
      );
    } else {
      onMarcadoresAtualizados();
    }
  }

  Future<void> alterarTrecho(String novoTrecho) async {
    praiaSelecionada = novoTrecho == 'Trechos' ? '' : novoTrecho;
    trechoSelecionado = praiaSelecionada;

    if (praiaSelecionada.isNotEmpty) {
      final estacao = estacoes.firstWhere(
        (e) => e.nome == praiaSelecionada,
        orElse: () => EstacaoMonitoramento.vazio(),
      );

      if (estacao.codigo.isNotEmpty) {
        await mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: estacao.coordenadas, zoom: 15),
          ),
        );
      }
    }

    notifyListeners();
    filtrarMarcadores();
  }

  List<String> obterTrechosFiltrados() {
    if (municipioSelecionado.isEmpty || municipioSelecionado == FiltrosLabels.todos) {
      return estacoes.map((e) => e.nome).toSet().toList();
    }
    return estacoes
        .where((e) => e.municipio == municipioSelecionado)
        .map((e) => e.nome)
        .toSet()
        .toList();
  }


}
