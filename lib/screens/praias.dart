import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/services/estacoes_service.dart';
import 'package:sudema_app/models/praia_marker.dart';
import 'package:sudema_app/screens/widgets/praias_widgets.dart';
import 'package:sudema_app/screens/widgets/estacao_info_card.dart';
import 'package:sudema_app/services/mapa_service.dart';
import 'package:sudema_app/services/marcadores_service.dart';

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
    _inicializarTudo();
  }

  Future<void> _inicializarTudo() async {
    try {
      await _carregarIcones();
      await _loadEstacoesFromJson();
    } catch (e) {
      print("Erro na inicialização: $e");
      setState(() => _isLoadingEstacoes = false);
    }
  }

  Future<void> _loadEstacoesFromJson() async {
    try {
      _estacoes = await EstacoesService.carregarEstacoes();
      setState(() => _isLoadingEstacoes = false);
    } catch (e) {
      print("Erro: $e");
      setState(() => _isLoadingEstacoes = false);
    }
  }

  Future<void> _carregarIcones() async {
    try {
      _iconePropria = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(14, 14)),
        'assets/images/propria.png',
      );
      _iconeImpropria = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(14, 14)),
        'assets/images/impropria.png',
      );
      print('✅ Ícones carregados com sucesso.');
    } catch (e) {
      print('❌ Erro ao carregar ícones: $e');
    }
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
        final est = _estacoes.firstWhere((e) => e.codigo == pm.marker.markerId.value);
        final matchMun = municipioSelecionado.isEmpty || municipioSelecionado == 'Todos' || est.municipio == municipioSelecionado;
        final matchClass = classificacoesSelecionadas.contains(pm.classificacao);
        if (matchMun && matchClass) {
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
          });

          if (_estacoes.isNotEmpty && _todosMarcadores.isEmpty) {
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
        initialCameraPosition: CameraPosition(target: _initialPosition, zoom: currentZoom),
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

            // Calcula posição preferencial à direita do marcador
            double left = _overlayPosition!.dx + spacing;
            if (left + cardWidth > screenSize.width) {
              // Se ultrapassar a borda direita, posiciona à esquerda do marcador
              left = _overlayPosition!.dx - cardWidth - spacing;
            }
            left = left.clamp(8.0, screenSize.width - cardWidth - 8.0);

            // Centraliza verticalmente ao lado do marcador
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
)

        ],
      ),
    );
  }
}
