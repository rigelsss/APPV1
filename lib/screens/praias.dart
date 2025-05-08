import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/services/estacoes_service.dart';
import 'package:sudema_app/models/praia_marker.dart';
import 'package:sudema_app/screens/widgets/praias_widgets.dart'; // <- NOVO

class PraiasPage extends StatefulWidget {
  const PraiasPage({super.key});

  @override
  State<PraiasPage> createState() => _PraiasPageState();
}

class _PraiasPageState extends State<PraiasPage> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(-7.1202, -34.8802);
  final GlobalKey _mapKey = GlobalKey();

  List<EstacaoMonitoramento> _estacoes = [];
  bool _isLoadingEstacoes = true;

  List<String> classificacoesSelecionadas = ['Próprias', 'Impróprias'];
  String municipioSelecionado = '';
  String praiaSelecionada = '';

  double currentZoom = 11.0;
  final double minZoomToShowMarkers = 12.5;

  BitmapDescriptor? _iconePropria;
  BitmapDescriptor? _iconeImpropria;

  final List<PraiaMarker> _todosMarcadores = [];
  final Set<Marker> _marcadoresVisiveis = {};

  EstacaoMonitoramento? _estacaoSelecionada;
  Offset? _overlayPosition;

  @override
  void initState() {
    super.initState();
    _carregarIcones().then((_) => _loadEstacoesFromJson());
  }

  Future<void> _loadEstacoesFromJson() async {
    try {
      _estacoes = await EstacoesService.carregarEstacoes();
      setState(() => _isLoadingEstacoes = false);
      _gerarMarcadoresComSimulacao();
    } catch (e) {
      print("Erro: $e");
      setState(() => _isLoadingEstacoes = false);
    }
  }

  Future<void> _carregarIcones() async {
    _iconePropria = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(14, 14)),
      'assets/images/propria.png',
    );
    _iconeImpropria = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(14, 14)),
      'assets/images/impropria.png',
    );
  }

  void _gerarMarcadoresComSimulacao() {
    _todosMarcadores.clear();
    for (var est in _estacoes) {
      final icon = est.classificacao == 'Próprias' ? _iconePropria : _iconeImpropria;
      final marker = Marker(
        markerId: MarkerId(est.codigo),
        position: est.coordenadas,
        icon: icon ?? BitmapDescriptor.defaultMarker,
        onTap: () async {
          final screenCoord = await mapController.getScreenCoordinate(est.coordenadas);
          final RenderBox box = _mapKey.currentContext!.findRenderObject() as RenderBox;
          final mapPosition = box.localToGlobal(Offset.zero);

          final offset = Offset(
            screenCoord.x.toDouble() - mapPosition.dx,
            screenCoord.y.toDouble() - mapPosition.dy,
          );

          setState(() {
            _estacaoSelecionada = est;
            _overlayPosition = offset;
          });
        },
      );
      _todosMarcadores.add(PraiaMarker(marker: marker, classificacao: est.classificacao));
    }
    setState(() => _filtrarMarcadores());
  }

  void _filtrarMarcadores() {
    _marcadoresVisiveis.clear();
    if (currentZoom >= minZoomToShowMarkers) {
      for (var pm in _todosMarcadores) {
        final est = _estacoes.firstWhere((e) => e.codigo == pm.marker.markerId.value);
        final matchMun = municipioSelecionado.isEmpty || municipioSelecionado == 'Todos' || est.municipio == municipioSelecionado;
        final matchClass = classificacoesSelecionadas.contains(pm.classificacao);
        if (matchMun && matchClass) {
          _marcadoresVisiveis.add(pm.marker);
        }
      }
    }
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

  LatLng _calcularCentroMunicipio(List<EstacaoMonitoramento> lista) {
    final latSum = lista.map((e) => e.coordenadas.latitude).reduce((a, b) => a + b);
    final lngSum = lista.map((e) => e.coordenadas.longitude).reduce((a, b) => a + b);
    return LatLng(latSum / lista.length, lngSum / lista.length);
  }

  void _moverMapaParaMunicipio(String municipio) {
    final lista = _estacoes.where((e) => e.municipio == municipio).toList();
    if (lista.isNotEmpty) {
      final destino = _calcularCentroMunicipio(lista);
      mapController.animateCamera(CameraUpdate.newLatLngZoom(destino, 12.5));
    }
    _filtrarMarcadores();
  }

  String _getClassificacaoLabel() {
    if (classificacoesSelecionadas.length == 2) return 'Mostrar tudo';
    if (classificacoesSelecionadas.contains('Próprias')) return 'Mostrar apenas próprias';
    return 'Mostrar apenas impróprias';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingEstacoes) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text("Balneabilidade", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Container(
            color: Colors.grey.shade300,
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
                      popupItem(context, 'Mostrar tudo', classificacoesSelecionadas.length == 2),
                      popupItem(context, 'Mostrar apenas próprias', classificacoesSelecionadas.contains('Próprias') && classificacoesSelecionadas.length == 1),
                      popupItem(context, 'Mostrar apenas impróprias', classificacoesSelecionadas.contains('Impróprias') && classificacoesSelecionadas.length == 1),
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
                      _moverMapaParaMunicipio(value);
                    } else {
                      _filtrarMarcadores();
                    }
                  },
                ),
                const SizedBox(width: 8),
                buildFiltroPraia(),
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
                      _filtrarMarcadores();
                    });
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
                  initialCameraPosition: CameraPosition(target: _initialPosition, zoom: currentZoom),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  markers: _marcadoresVisiveis,
                ),
                if (_estacaoSelecionada != null && _overlayPosition != null)
                  Positioned(
                    left: (_overlayPosition!.dx - 130).clamp(16, MediaQuery.of(context).size.width - 276),
                    top: (_overlayPosition!.dy - 200).clamp(16, MediaQuery.of(context).size.height - 180),
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 260,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_estacaoSelecionada!.nome} - ${_estacaoSelecionada!.municipio}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _estacaoSelecionada!.endereco,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Estação: ${_estacaoSelecionada!.codigo}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _estacaoSelecionada!.classificacao == 'Próprias'
                                  ? 'Própria para banho'
                                  : 'Imprópria para banho',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: _estacaoSelecionada!.classificacao == 'Próprias'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
