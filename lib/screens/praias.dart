import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sudema_app/services/marcadores_service.dart';
import 'package:sudema_app/services/mapa_service.dart';
import 'package:sudema_app/models/praia_marker.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';
import 'package:sudema_app/screens/widgets/praias_widgets.dart';
import 'package:sudema_app/screens/widgets/estacao_info_card.dart';
import 'package:geolocator/geolocator.dart';

class PraiasPage extends StatefulWidget {
  const PraiasPage({super.key});

  @override
  State<PraiasPage> createState() => _PraiasPageState();
}

class _PraiasPageState extends State<PraiasPage> {
  late GoogleMapController mapController;
  final GlobalKey _mapKey = GlobalKey();

  List<EstacaoMonitoramento> _estacoes = [];
  bool _isLoadingEstacoes = true;

  List<String> classificacoesSelecionadas = ['Próprias', 'Impróprias'];
  String municipioSelecionado = '';
  String praiaSelecionada = '';
  String trechoSelecionado = '';

  double currentZoom = 14.0;
  final double minZoomToShowMarkers = 12.5;

  BitmapDescriptor? _iconePropria;
  BitmapDescriptor? _iconeImpropria;

  final List<PraiaMarker> _todosMarcadores = [];
  final Set<Marker> _marcadoresVisiveis = {};

  EstacaoMonitoramento? _estacaoSelecionada;
  Offset? _overlayPosition;

  bool _mapaCriado = false;

  @override
  void initState() {
    super.initState();
    _inicializarMapa();
  }

  Future<void> _inicializarMapa() async {
    await _carregarIcones();
    await _carregarEstacoesDaAPI();
    await _centralizarNaLocalizacaoAtual();
    if (_mapaCriado) _gerarMarcadoresComSimulacao();
  }

  Future<void> _centralizarNaLocalizacaoAtual() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    final userLatLng = LatLng(position.latitude, position.longitude);

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: userLatLng, zoom: 14.5),
    ));
  }

  Future<void> _carregarIcones() async {
    try {
      _iconePropria = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/propria.png',
      );
      _iconeImpropria = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/impropria.png',
      );
    } catch (e) {
      print('❌ Erro ao carregar ícones: $e');
    }
  }

  Future<void> _carregarEstacoesDaAPI() async {
    try {
      final response = await http.get(Uri.parse('https://homolog.sigma.pb.gov.br/sislia/api/v1/balneabilidade/municipios-com-trechos'));
      if (response.statusCode == 200) {
        final dados = json.decode(utf8.decode(response.bodyBytes));
        _estacoes = _mapearDadosDaAPI(dados);
      } else {
        throw Exception('Erro ao buscar dados da API: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erro ao carregar dados da API: $e');
    } finally {
      setState(() => _isLoadingEstacoes = false);
    }
  }

  List<EstacaoMonitoramento> _mapearDadosDaAPI(dynamic json) {
    final List<EstacaoMonitoramento> estacoes = [];
    for (var municipio in json) {
      final String nomeMunicipio = municipio['municipio'];
      for (var trecho in municipio['trechos']) {
        estacoes.add(
          EstacaoMonitoramento(
            nome: trecho['trecho'] ?? '',
            codigo: trecho['estacao'] ?? '',
            endereco: trecho['trecho'] ?? '',
            municipio: nomeMunicipio,
            coordenadas: LatLng(trecho['latitude'], trecho['longitude']),
            classificacao: trecho['classificacao']?.contains('Imprópria') == true ? 'Impróprias' : 'Próprias',
          ),
        );
      }
    }
    return estacoes;
  }

  List<String> get trechosDisponiveis {
    final trechos = _estacoes.map((e) => e.nome).toSet().toList();
    trechos.sort();
    return ['Todos'] + trechos;
  }

  void _gerarMarcadoresComSimulacao() {
    _todosMarcadores.clear();

    final novosMarcadores = MarcadoresService.gerarMarcadores(
      estacoes: _estacoes,
      iconePropria: _iconePropria ?? BitmapDescriptor.defaultMarker,
      iconeImpropria: _iconeImpropria ?? BitmapDescriptor.defaultMarker,
      getScreenCoordinate: mapController.getScreenCoordinate,
      getMapOffset: () {
        final RenderBox box = _mapKey.currentContext!.findRenderObject() as RenderBox;
        return box.localToGlobal(Offset.zero);
      },
      onTapEstacao: (est, offset) {
        setState(() {
          _estacaoSelecionada = est;
          _overlayPosition = offset;
        });
      },
    );

    _todosMarcadores.addAll(novosMarcadores);
    _filtrarMarcadores();
  }

  void _filtrarMarcadores() {
    _marcadoresVisiveis.clear();
    if (currentZoom >= minZoomToShowMarkers) {
      for (var pm in _todosMarcadores) {
        final est = _estacoes.firstWhere((e) => e.codigo == pm.marker.markerId.value, orElse: () => EstacaoMonitoramento.vazio());

        final matchMun = municipioSelecionado.isEmpty || municipioSelecionado == 'Todos' || est.municipio == municipioSelecionado;
        final matchClass = classificacoesSelecionadas.contains(pm.classificacao);
        final matchTrecho = trechoSelecionado.isEmpty || trechoSelecionado == 'Todos' || est.nome == trechoSelecionado;

        if (matchMun && matchClass && matchTrecho) {
          _marcadoresVisiveis.add(pm.marker);
        }
      }
    }
    setState(() {});
  }

  void _toggleClassificacao(String item) {
    setState(() {
      if (item == 'Mostrar tudo') {
        classificacoesSelecionadas = ['Próprias', 'Impróprias'];
      } else if (item == 'Mostrar apenas próprias') {
        classificacoesSelecionadas = ['Próprias'];
      } else if (item == 'Mostrar apenas impróprias') {
        classificacoesSelecionadas = ['Impróprias'];
      }
      _filtrarMarcadores();
    });
  }

  String _getClassificacaoLabel() {
    if (classificacoesSelecionadas.length == 2) return 'Mostrar tudo';
    if (classificacoesSelecionadas.contains('Próprias')) return 'Mostrar apenas próprias';
    return 'Mostrar apenas impróprias';
  }

  Widget buildFiltroTrecho() {
    List<String> trechosFiltrados;

    if (municipioSelecionado.isEmpty || municipioSelecionado == 'Todos') {
      trechosFiltrados = _estacoes.map((e) => e.nome).toSet().toList();
    } else {
      trechosFiltrados = _estacoes
          .where((e) => e.municipio == municipioSelecionado)
          .map((e) => e.nome)
          .toSet()
          .toList();
    }

    trechosFiltrados.sort();
    trechosFiltrados.insert(0, 'Trechos');

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          PopupMenuButton<String>(
            onSelected: (value) async {
              setState(() {
                praiaSelecionada = value == 'Trechos' ? '' : value;
                trechoSelecionado = praiaSelecionada;
              });

              if (praiaSelecionada.isNotEmpty) {
                final estacao = _estacoes.firstWhere(
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

              _filtrarMarcadores();
            },
            itemBuilder: (context) {
              return trechosFiltrados.map((trecho) {
                return PopupMenuItem<String>(
                  value: trecho,
                  child: Text(trecho),
                );
              }).toList();
            },
            child: popupButton(praiaSelecionada.isEmpty ? 'Trechos' : praiaSelecionada),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _radioMenuItem(String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: _getClassificacaoLabel(),
            onChanged: (_) => Navigator.pop(context, value),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingEstacoes) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: const Text(
              "Balneabilidade",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Trechos monitorados", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text("${_estacoes.length}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  height: 35,
                  child: PopupMenuButton<String>(
                    onSelected: _toggleClassificacao,
                    itemBuilder: (_) => [
                      _radioMenuItem('Mostrar tudo'),
                      _radioMenuItem('Mostrar apenas próprias'),
                      _radioMenuItem('Mostrar apenas impróprias'),
                    ],
                    child: popupButton(_getClassificacaoLabel()),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                buildFiltroMunicipio(
                  municipioSelecionado: municipioSelecionado,
                  onSelected: (value) {
                    setState(() => municipioSelecionado = value);
                    if (value.isNotEmpty && value != 'Todos') {
                      MapaService.moverMapaParaMunicipio(
                        controller: mapController,
                        estacoes: _estacoes,
                        municipio: value,
                        onComplete: _filtrarMarcadores,
                      );
                    } else {
                      _filtrarMarcadores();
                    }
                  },
                ),
                const SizedBox(width: 8),
                buildFiltroTrecho(),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  key: _mapKey,
                  onMapCreated: (controller) async {
                    mapController = controller;
                    final zoomLevel = await controller.getZoomLevel();
                    setState(() {
                      currentZoom = zoomLevel;
                      _mapaCriado = true;
                    });
                    if (_estacoes.isNotEmpty) {
                      _gerarMarcadoresComSimulacao();
                    }
                  },
                  onTap: (_) {
                    setState(() {
                      _estacaoSelecionada = null;
                      _overlayPosition = null;
                    });
                  },
                  onCameraMove: (pos) {
                    setState(() {
                      currentZoom = pos.zoom;
                      _filtrarMarcadores();
                    });
                  },
                  initialCameraPosition: const CameraPosition(
                  target: LatLng(-7.1202, -34.8802), 
                  zoom: 12.0,
                  ),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: _marcadoresVisiveis,
                ),
                if (_estacaoSelecionada != null && _overlayPosition != null)
                  Builder(
                    builder: (context) {
                      final screenSize = MediaQuery.of(context).size;
                      const cardWidth = 260.0;
                      const cardHeight = 160.0;
                      const spacing = 12.0;

                      double left = _overlayPosition!.dx + spacing;
                      if (left + cardWidth > screenSize.width) {
                        left = _overlayPosition!.dx - cardWidth - spacing;
                      }
                      left = left.clamp(8.0, screenSize.width - cardWidth - 8.0);

                      double top = (_overlayPosition!.dy - cardHeight / 2).clamp(8.0, screenSize.height - cardHeight - 8.0);

                      return Positioned(
                        left: left,
                        top: top,
                        child: EstacaoInfoCard(estacao: _estacaoSelecionada!),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
