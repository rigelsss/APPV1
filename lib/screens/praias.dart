import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  int totalPraias = 62;
  late int praiasProprias = Random().nextInt(62 + 1);
  late int praiasImproprias = totalPraias - praiasProprias;

  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(-7.1202, -34.8802);

  List<String> classificacoesSelecionadas = [];
  String municipioSelecionado = ''; // agora começa sem seleção
  String praiaSelecionada = '';

  final List<String> municipios = [
    'Todos',
    'Mataraca',
    'Baia da Traição',
    'Rio Tinto',
    'Lucena',
    'Cabedelo',
    'João Pessoa',
    'Conde',
    'Pitimbú',
  ];

  final Map<String, LatLng> coordenadasMunicipios = {
    'Mataraca': LatLng(-6.594477, -34.967659),
    'Baia da Traição': LatLng(-6.697682, -34.935901),
    'Rio Tinto': LatLng(-6.812848, -34.915088),
    'Lucena': LatLng(-6.904164, -34.860043),
    'Cabedelo': LatLng(-7.028684, -34.839712),
    'João Pessoa': LatLng(-7.111758, -34.823013),
    'Conde': LatLng(-7.278528, -34.800968),
    'Pitimbú': LatLng(-7.475120, -34.808107),
  };

  BitmapDescriptor? _iconePropria;
  BitmapDescriptor? _iconeImpropria;

  final List<_PraiaMarker> _todosMarcadores = [];
  final Set<Marker> _marcadoresVisiveis = {};

  @override
  void initState() {
    super.initState();
    final random = Random();
    praiasProprias = random.nextInt(totalPraias);
    praiasImproprias = totalPraias - praiasProprias;
    _carregarIcones().then((_) => _adicionarMarcadoresSimulados());
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

  void _adicionarMarcadoresSimulados() {
    final random = Random();
    _todosMarcadores.clear();
    for (var entry in coordenadasMunicipios.entries) {
      bool isPropria = random.nextBool();
      _todosMarcadores.add(_PraiaMarker(
        marker: Marker(
          markerId: MarkerId(entry.key),
          position: entry.value,
          icon: isPropria ? _iconePropria! : _iconeImpropria!,
          infoWindow: InfoWindow(
            title: entry.key,
            snippet: isPropria ? 'Própria para banho' : 'Imprópria para banho',
          ),
        ),
        classificacao: isPropria ? 'Próprias' : 'Impróprias',
      ));
    }
    _filtrarMarcadores();
  }

  void _filtrarMarcadores() {
    setState(() {
      _marcadoresVisiveis.clear();
      _marcadoresVisiveis.addAll(_todosMarcadores
          .where((m) => classificacoesSelecionadas.contains(m.classificacao))
          .map((m) => m.marker));
    });
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

  void _moverMapaParaMunicipio(String municipio) {
    if (coordenadasMunicipios.containsKey(municipio)) {
      final destino = coordenadasMunicipios[municipio]!;
      mapController.animateCamera(CameraUpdate.newLatLngZoom(destino, 13));
    }
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
            color: Colors.grey.shade100,
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
                    const Text(
                      "Trechos monitorados",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$totalPraias",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
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
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 11),
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
          border: Border.all(
            color: Colors.grey.shade500,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11),
              ),
            ),
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
