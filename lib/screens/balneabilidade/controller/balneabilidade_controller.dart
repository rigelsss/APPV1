/// BALNEABILIDADE_CONTROLLER
///
/// Responsável por: Gerenciar estado e lógica do módulo de balneabilidade das praias.
/// Utilizado em: Controle completo da tela de balneabilidade com Provider pattern.
/// 
/// Este controller gerencia:
/// - Carregamento de estações de monitoramento da API SUDEMA
/// - Controle do mapa interativo do Google Maps
/// - Sistema de filtros por município, praia e classificação
/// - Marcadores dinâmicos com ícones personalizados
/// - Localização do usuário e navegação no mapa
/// - Overlay de informações das estações selecionadas

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

/// Labels para opções de classificação de balneabilidade
class ClassificacaoLabels {
  static const todas = 'Mostrar tudo';
  static const proprias = 'Mostrar apenas próprias';
  static const improprias = 'Mostrar apenas impróprias';
}

class BalneabilidadeController extends ChangeNotifier {
  // Controle do Google Maps
  late GoogleMapController mapController;  // Controlador do mapa
  final GlobalKey mapKey = GlobalKey();    // Chave para referência do widget do mapa

  // Localização do usuário
  LatLng? posicaoAtualUsuario;             // Coordenadas GPS do usuário
  Marker? marcadorUsuario;                 // Marcador da posição do usuário
  BitmapDescriptor? iconeUsuario;          // Ícone personalizado do usuário

  // Dados das estações de monitoramento
  List<EstacaoMonitoramento> estacoes = []; // Lista de estações da API SUDEMA
  bool isLoadingEstacoes = true;           // Estado de carregamento das estações

  // Sistema de filtros
  List<String> classificacoesSelecionadas = ['Próprias', 'Impróprias']; // Filtro de classificação
  String municipioSelecionado = '';        // Município selecionado no filtro
  String praiaSelecionada = '';            // Praia selecionada no filtro
  String trechoSelecionado = '';           // Trecho específico selecionado

  // Controle de zoom do mapa
  double currentZoom = 14.0;               // Nível de zoom atual
  final double minZoomToShowMarkers = 12.5; // Zoom mínimo para exibir marcadores

  // Ícones personalizados para marcadores
  BitmapDescriptor? iconePropria;          // Ícone para praias próprias
  BitmapDescriptor? iconeImpropria;        // Ícone para praias impróprias

  // Gerenciamento de marcadores
  final List<PraiaMarker> todosMarcadores = [];  // Todos os marcadores gerados
  final Set<Marker> marcadoresVisiveis = {};     // Marcadores atualmente visíveis

  // Overlay de informações
  EstacaoMonitoramento? estacaoSelecionada; // Estação selecionada para exibir detalhes
  Offset? overlayPosition;                  // Posição do overlay na tela

  // Estado do mapa
  bool mapaCriado = false;                  // Flag indicando se mapa foi inicializado

  /// inicializar
  ///
  /// Descrição: Inicializa o controller carregando dados e configurações necessárias.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Sequência: ícones → estações da API → localização → marcadores.
  Future<void> inicializar() async {
    await _carregarIcones();              // Carrega ícones personalizados
    await _carregarEstacoesDaAPI();       // Busca estações da API SUDEMA
    await centralizarNaLocalizacaoAtual(); // Obtém GPS do usuário
    if (mapaCriado) gerarMarcadoresComSimulacao(); // Gera marcadores se mapa pronto
  }

  /// _carregarIcones
  ///
  /// Descrição: Carrega ícones personalizados para marcadores do mapa.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Carrega ícones para praias próprias, impróprias e localização do usuário.
  Future<void> _carregarIcones() async {
    try {
      iconePropria = await IconesService.carregarIconePropria();     // Ícone verde
      iconeImpropria = await IconesService.carregarIconeImpropria(); // Ícone vermelho
      iconeUsuario = await IconesService.carregarIconeUsuario();     // Ícone azul
    } catch (e) {
      throw Exception('Erro ao carregar ícones: $e');
    }
  }

  /// centralizarNaLocalizacaoAtual
  ///
  /// Descrição: Obtém localização GPS do usuário e centraliza mapa.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Cria marcador do usuário e anima câmera para sua posição.
  Future<void> centralizarNaLocalizacaoAtual() async {
    final localizacao = await LocalizacaoService.obterLocalizacaoAtual();
    if (localizacao == null) return; // Falha ao obter GPS

    posicaoAtualUsuario = localizacao;
    // Cria marcador personalizado para o usuário
    marcadorUsuario = Marker(
      markerId: const MarkerId('usuario'),
      position: localizacao,
      icon: iconeUsuario ?? BitmapDescriptor.defaultMarker,
      infoWindow: const InfoWindow(title: 'Sua localização'),
    );

    // Anima câmera para centralizar na localização do usuário
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: localizacao, zoom: 14.5),
      ),
    );

    notifyListeners(); // Notifica widgets para rebuild
  }

  /// _carregarEstacoesDaAPI
  ///
  /// Descrição: Carrega estações de monitoramento da API SUDEMA.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Trata erros da API e atualiza estado de carregamento.
  Future<void> _carregarEstacoesDaAPI() async {
    try {
      estacoes = await BalneabilidadeService.carregarEstacoes();
    } on ApiException catch (e) {
      print('Erro API: ${e.message}'); // Log do erro específico
    } finally {
      isLoadingEstacoes = false; // Para loading independente do resultado
      notifyListeners();
    }
  }

  /// limparSelecaoEstacao
  ///
  /// Descrição: Remove seleção de estação e fecha overlay de informações.
  /// Parâmetros: nenhum
  /// Retorno: void
  void limparSelecaoEstacao() {
    estacaoSelecionada = null; // Remove estação selecionada
    overlayPosition = null;    // Remove posição do overlay
    notifyListeners();
  }

  /// gerarMarcadoresComSimulacao
  ///
  /// Descrição: Gera marcadores no mapa para todas as estações carregadas.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Cria marcadores com ícones personalizados e callbacks de interação.
  void gerarMarcadoresComSimulacao() {
    todosMarcadores.clear(); // Limpa marcadores anteriores

    // Gera novos marcadores via service
    final novosMarcadores = MarcadoresService.gerarMarcadores(
      estacoes: estacoes,
      iconePropria: iconePropria ?? BitmapDescriptor.defaultMarker,
      iconeImpropria: iconeImpropria ?? BitmapDescriptor.defaultMarker,
      getScreenCoordinate: mapController.getScreenCoordinate, // Conversão para coordenadas de tela
      getMapOffset: () {
        // Obtém offset do widget do mapa na tela
        final RenderBox box = mapKey.currentContext!.findRenderObject() as RenderBox;
        return box.localToGlobal(Offset.zero);
      },
      onTapEstacao: (est, offset) {
        // Callback quando usuário toca em uma estação
        estacaoSelecionada = est;
        overlayPosition = offset;
        notifyListeners();
      },
    );

    todosMarcadores.addAll(novosMarcadores);
    filtrarMarcadores(); // Aplica filtros aos novos marcadores
  }

  /// filtrarMarcadores
  ///
  /// Descrição: Aplica filtros ativos e atualiza marcadores visíveis no mapa.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Filtra por município, trecho, classificação e nível de zoom.
  void filtrarMarcadores() {
    marcadoresVisiveis.clear();
    // Aplica todos os filtros via service
    marcadoresVisiveis.addAll(
      FiltrosService.filtrar(
        todosMarcadores: todosMarcadores,
        estacoes: estacoes,
        municipioSelecionado: municipioSelecionado,
        trechoSelecionado: trechoSelecionado,
        classificacoesSelecionadas: classificacoesSelecionadas,
        currentZoom: currentZoom,                // Zoom atual do mapa
        minZoomToShowMarkers: minZoomToShowMarkers, // Zoom mínimo para exibir
      ),
    );
    notifyListeners();
  }

  /// resetarFiltros
  ///
  /// Descrição: Limpa seleções de município, praia e trecho.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Usado quando muda classificação para resetar outros filtros.
  void resetarFiltros() {
    municipioSelecionado = '';
    praiaSelecionada = '';
    trechoSelecionado = '';
  }

  /// toggleClassificacao
  ///
  /// Descrição: Altera filtro de classificação (todas/próprias/impróprias).
  /// Parâmetros:
  /// - item: nova classificação selecionada
  /// Retorno: void
  ///
  /// Reseta outros filtros e recentra mapa na localização do usuário.
  void toggleClassificacao(String item) async {
    // Define quais classificações mostrar baseado na seleção
    if (item == ClassificacaoLabels.todas) {
      classificacoesSelecionadas = ['Próprias', 'Impróprias'];
    } else if (item == ClassificacaoLabels.proprias) {
      classificacoesSelecionadas = ['Próprias'];
    } else if (item == ClassificacaoLabels.improprias) {
      classificacoesSelecionadas = ['Impróprias'];
    }

    resetarFiltros(); // Limpa filtros de localização

    // Recentra mapa na localização do usuário
    if (posicaoAtualUsuario != null) {
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: posicaoAtualUsuario!, zoom: 14.5),
        ),
      );
    }

    filtrarMarcadores(); // Aplica novo filtro
  }

  /// getClassificacaoLabel
  ///
  /// Descrição: Retorna label atual do filtro de classificação.
  /// Parâmetros: nenhum
  /// Retorno: String - label para exibir na interface
  ///
  /// Usado para mostrar estado atual do filtro no dropdown.
  String getClassificacaoLabel() {
    return classificacoesSelecionadas.length == 2
        ? ClassificacaoLabels.todas      // Ambas selecionadas = todas
        : classificacoesSelecionadas.contains('Próprias')
            ? ClassificacaoLabels.proprias   // Apenas próprias
            : ClassificacaoLabels.improprias; // Apenas impróprias
  }

  /// alterarMunicipio
  ///
  /// Descrição: Altera filtro de município e navega mapa para a região.
  /// Parâmetros:
  /// - novoMunicipio: município selecionado
  /// - onMarcadoresAtualizados: callback após atualização
  /// Retorno: void
  ///
  /// Limpa filtros de trecho e move câmera para o município.
  void alterarMunicipio(String novoMunicipio, VoidCallback onMarcadoresAtualizados) {
    municipioSelecionado = novoMunicipio;
    trechoSelecionado = '';  // Limpa seleção de trecho
    praiaSelecionada = '';   // Limpa seleção de praia
    notifyListeners();

    // Move mapa para o município se não for "Todos"
    if (novoMunicipio.isNotEmpty && novoMunicipio != 'Todos') {
      MapaService.moverMapaParaMunicipio(
        controller: mapController,
        estacoes: estacoes,
        municipio: novoMunicipio,
        onComplete: onMarcadoresAtualizados, // Callback após animação
      );
    } else {
      onMarcadoresAtualizados(); // Executa callback imediatamente
    }
  }

  /// alterarTrecho
  ///
  /// Descrição: Altera filtro de trecho/praia e navega para a estação.
  /// Parâmetros:
  /// - novoTrecho: trecho/praia selecionada
  /// Retorno: Future<void>
  ///
  /// Encontra estação correspondente e centraliza mapa nela.
  Future<void> alterarTrecho(String novoTrecho) async {
    praiaSelecionada = novoTrecho == 'Trechos' ? '' : novoTrecho;
    trechoSelecionado = praiaSelecionada;

    // Se praia selecionada, navega para sua estação
    if (praiaSelecionada.isNotEmpty) {
      final estacao = estacoes.firstWhere(
        (e) => e.nome == praiaSelecionada,
        orElse: () => EstacaoMonitoramento.vazio(), // Fallback se não encontrar
      );

      // Anima câmera para a estação encontrada
      if (estacao.codigo.isNotEmpty) {
        await mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: estacao.coordenadas, zoom: 15), // Zoom maior para detalhes
          ),
        );
      }
    }

    notifyListeners();
    filtrarMarcadores(); // Aplica filtro de trecho
  }

  /// obterTrechosFiltrados
  ///
  /// Descrição: Retorna lista de trechos filtrada pelo município selecionado.
  /// Parâmetros: nenhum
  /// Retorno: List<String> - nomes dos trechos disponíveis
  ///
  /// Usado para popular dropdown de trechos baseado no município.
  List<String> obterTrechosFiltrados() {
    // Se nenhum município selecionado, mostra todos os trechos
    if (municipioSelecionado.isEmpty || municipioSelecionado == FiltrosLabels.todos) {
      return estacoes.map((e) => e.nome).toSet().toList();
    }
    // Filtra trechos apenas do município selecionado
    return estacoes
        .where((e) => e.municipio == municipioSelecionado)
        .map((e) => e.nome)
        .toSet() // Remove duplicatas
        .toList();
  }


}
