import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/services/estacoes_service.dart'; 

class PraiasPage extends StatefulWidget {
  const PraiasPage({super.key});

  @override
  State<PraiasPage> createState() => _PraiasPageState();
}

class _PraiaMarker {
  final Marker marker;
  final String classificacao;
  _PraiaMarker({required this.marker, required this.classificacao});
}

class _PraiasPageState extends State<PraiasPage> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(-7.1202, -34.8802);

  // dados carregados do JSON
  List<EstacaoMonitoramento> _estacoes = [];
  bool _isLoadingEstacoes = true;

  // filtros e zoom
  List<String> classificacoesSelecionadas = ['Próprias', 'Impróprias'];
  String municipioSelecionado = '';
  String praiaSelecionada = '';

  double currentZoom = 11.0;
  final double minZoomToShowMarkers = 12.5;

  final List<String> municipios = [
    'Todos',
    'Mataraca',
    'Baia da Traição',
    'Rio Tinto',
    'Lucena',
    'Cabedelo',
    'João Pessoa',
    'Conde',
    'Pitimbú'
  ];

  BitmapDescriptor? _iconePropria;
  BitmapDescriptor? _iconeImpropria;

  // marcadores internos
  final List<_PraiaMarker> _todosMarcadores = [];
  final Set<Marker> _marcadoresVisiveis = {};

  @override
  void initState() {
    super.initState();
    print("▶ Iniciando carregamento das estações...");
    _loadEstacoesFromJson();
    _carregarIcones();
  }

  Future<void> _loadEstacoesFromJson() async {
    try {
      print("  • Carregando JSON em assets/json/balneabilidade.json");
      final jsonString = await rootBundle.loadString('assets/json/balneabilidade.json');
      print("  • JSON carregado (${jsonString.length} caracteres)");
      final List<dynamic> jsonList = json.decode(jsonString);
      print("  • ${jsonList.length} registros encontrados no JSON");

      final random = Random();
      _estacoes = jsonList.map((item) {
        // extrai latitude/longitude
        final lat = item['coordenadas']['latitude'];
        final lng = item['coordenadas']['longitude'];
        // se o campo condicao vier vazio, sorteia aleatoriamente
        final cond = (item['condicao'] as String).toLowerCase();
        final classificacao = cond.isNotEmpty
            ? (cond.contains('propr') ? 'Próprias' : 'Impróprias')
            : (random.nextBool() ? 'Próprias' : 'Impróprias');
        return EstacaoMonitoramento(
          nome: item['nome'],
          codigo: item['codigo'],
          endereco: item['endereco'],
          municipio: item['municipio'],
          coordenadas: LatLng(lat, lng),
          classificacao: classificacao,
        );
      }).toList();

      print("  • Objetos EstacaoMonitoramento criados: ${_estacoes.length}");
      setState(() {
        _isLoadingEstacoes = false;
      });
      // gerar marcadores agora que temos as estações
      _gerarMarcadoresComSimulacao();
    } catch (e, st) {
      print("✖ Erro ao carregar estações: $e");
      print(st);
      setState(() {
        _isLoadingEstacoes = false;
      });
    }
  }

  Future<void> _carregarIcones() async {
    try {
      print("  • Carregando ícones de praia...");
      _iconePropria = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(14, 14)),
        'assets/images/propria.png',
      );
      _iconeImpropria = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(14, 14)),
        'assets/images/impropria.png',
      );
      print("  • Ícones carregados com sucesso");
    } catch (e) {
      print("✖ Erro ao carregar ícones: $e");
    }
  }

  void _gerarMarcadoresComSimulacao() {
    print("▶ Gerando marcadores a partir de _estacoes...");
    _todosMarcadores.clear();
    for (var est in _estacoes) {
      final icon = est.classificacao == 'Próprias' ? _iconePropria : _iconeImpropria;
      final marker = Marker(
        markerId: MarkerId(est.codigo),
        position: est.coordenadas,
        icon: icon ?? BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: est.nome,
          snippet: '${est.endereco}\n${est.classificacao}',
        ),
      );
      _todosMarcadores.add(_PraiaMarker(marker: marker, classificacao: est.classificacao));
      print("  • Marcador criado: ${est.nome} (${est.classificacao})");
    }
    // aplica filtro inicial
    setState(() {
      _filtrarMarcadores();
    });
  }

  void _filtrarMarcadores() {
    _marcadoresVisiveis.clear();
    if (currentZoom >= minZoomToShowMarkers) {
      for (var pm in _todosMarcadores) {
        // encontra a estacao pelo markerId
        final est = _estacoes.firstWhere((e) => e.codigo == pm.marker.markerId.value);
        final matchMun = municipioSelecionado.isEmpty ||
            municipioSelecionado == 'Todos' ||
            est.municipio == municipioSelecionado;
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
    if (classificacoesSelecionadas.contains('Impróprias')) return 'Mostrar apenas impróprias';
    return 'Mostrar tudo';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: const Text(
              "Balneabilidade",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            color: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Trechos monitorados",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text("${_estacoes.length}",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  height: 35,
                  child: PopupMenuButton<String>(
                    onSelected: _toggleClassificacao,
                    itemBuilder: (_) => [
                      _popupItem('Mostrar tudo', classificacoesSelecionadas.length == 2),
                      _popupItem('Mostrar apenas próprias',
                          classificacoesSelecionadas.contains('Próprias') && classificacoesSelecionadas.length == 1),
                      _popupItem('Mostrar apenas impróprias',
                          classificacoesSelecionadas.contains('Impróprias') && classificacoesSelecionadas.length == 1),
                    ],
                    child: _popupButton(_getClassificacaoLabel()),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFiltroMunicipio(),
                const SizedBox(width: 8),
                _buildFiltroPraia(),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                onMapCreated: (controller) async {
                  mapController = controller;
                  final zoomLevel = await controller.getZoomLevel();
                  setState(() {
                    currentZoom = zoomLevel;
                    _filtrarMarcadores();
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroMunicipio() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Filtrar por", style: TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() => municipioSelecionado = value);
                if (value.isNotEmpty && value != 'Todos') {
                  _moverMapaParaMunicipio(value);
                } else {
                  _filtrarMarcadores();
                }
              },
              itemBuilder: (_) =>
                  municipios.map((m) => PopupMenuItem<String>(value: m, child: Text(m))).toList(),
              child: _popupButton(municipioSelecionado.isEmpty ? 'Municípios' : municipioSelecionado),
            ),
          ],
        ),
      );

  Widget _buildFiltroPraia() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _popupButton("Trecho"),
          ],
        ),
      );

  Widget _popupButton(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade500, width: 1.2),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11))),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          ],
        ),
      );

  PopupMenuItem<String> _popupItem(String label, bool isChecked) => PopupMenuItem<String>(
        value: label,
        child: Row(
          children: [
            Checkbox(value: isChecked, onChanged: (_) => Navigator.pop(context, label)),
            Flexible(child: Text(label)),
          ],
        ),
      );
}
