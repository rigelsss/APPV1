import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/data/estacoes_monitoramento.dart';

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

  final List<_PraiaMarker> _todosMarcadores = [];
  final Set<Marker> _marcadoresVisiveis = {};

  @override
  void initState() {
    super.initState();
    _carregarIcones().then((_) => _gerarMarcadoresComSimulacao());
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
    final random = Random();

    for (var estacao in estacoes) {
      final isPropria = random.nextBool();
      final classificacao = isPropria ? 'Próprias' : 'Impróprias';
      final icon = isPropria ? _iconePropria : _iconeImpropria;

      _todosMarcadores.add(_PraiaMarker(
        marker: Marker(
          markerId: MarkerId(estacao.codigo),
          position: estacao.coordenadas,
          icon: icon!,
          infoWindow: InfoWindow(
            title: estacao.nome,
            snippet: '${estacao.endereco}\n$classificacao',
          ),
        ),
        classificacao: classificacao,
      ));
    }

    setState(() {
      _filtrarMarcadores();
    });
  }

  void _filtrarMarcadores() {
    _marcadoresVisiveis.clear();

    if (currentZoom >= minZoomToShowMarkers) {
      _marcadoresVisiveis.addAll(
        _todosMarcadores.where((m) {
          final estacao = estacoes.firstWhere((e) => e.codigo == m.marker.markerId.value);
          final matchMunicipio = municipioSelecionado.isEmpty ||
              municipioSelecionado == 'Todos' ||
              estacao.municipio == municipioSelecionado;
          final matchClassificacao = classificacoesSelecionadas.contains(m.classificacao);
          return matchMunicipio && matchClassificacao;
        }).map((m) => m.marker),
      );
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

  LatLng _calcularCentroMunicipio(List estacoesMunicipio) {
    final lat = estacoesMunicipio.map((e) => e.coordenadas.latitude).reduce((a, b) => a + b) / estacoesMunicipio.length;
    final lng = estacoesMunicipio.map((e) => e.coordenadas.longitude).reduce((a, b) => a + b) / estacoesMunicipio.length;
    return LatLng(lat, lng);
  }

  void _moverMapaParaMunicipio(String municipio) {
    final estacoesMunicipio = estacoes.where((e) => e.municipio == municipio).toList();
    if (estacoesMunicipio.isNotEmpty) {
      final destino = _calcularCentroMunicipio(estacoesMunicipio);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Trechos monitorados", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text("${estacoes.length}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  height: 35,
                  child: PopupMenuButton<String>(
                    onSelected: _toggleClassificacao,
                    itemBuilder: (context) => [
                      _popupItem('Mostrar tudo', classificacoesSelecionadas.length == 2),
                      _popupItem('Mostrar apenas próprias', classificacoesSelecionadas.contains('Próprias') && classificacoesSelecionadas.length == 1),
                      _popupItem('Mostrar apenas impróprias', classificacoesSelecionadas.contains('Impróprias') && classificacoesSelecionadas.length == 1),
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
                onCameraMove: (position) {
                  setState(() {
                    currentZoom = position.zoom;
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
              itemBuilder: (context) =>
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
