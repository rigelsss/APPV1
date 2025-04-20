import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

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
  final int totalPraias = 62;
  final int praiasProprias = 58;
  final int praiasImproprias = 4;

  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(-7.1202, -34.8802);

  List<String> classificacoesSelecionadas = [];
  String municipioSelecionado = 'Todos';
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
      if (item == 'Selecionar tudo') {
        classificacoesSelecionadas = classificacoesSelecionadas.length < 2 ? ['Próprias', 'Impróprias'] : [];
      } else {
        classificacoesSelecionadas.contains(item)
            ? classificacoesSelecionadas.remove(item)
            : classificacoesSelecionadas.add(item);
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
    if (classificacoesSelecionadas.length == 2) return 'Selecionar tudo';
    if (classificacoesSelecionadas.length == 1) return classificacoesSelecionadas.first;
    return 'Classificação';
  }

  @override
  Widget build(BuildContext context) {
    double percentualPropria = praiasProprias / totalPraias * 100;
    double percentualImpropria = praiasImproprias / totalPraias * 100;

    final Map<String, double> dataMap = {
      "Própria": percentualPropria,
      "Imprópria": percentualImpropria,
    };

    return Scaffold(
      body: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Balneabilidade", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTotalCard(),
                  const SizedBox(width: 12),
                  _buildStatusCard(dataMap, percentualPropria, percentualImpropria),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildFiltroClassificacao(),
                const SizedBox(width: 8),
                _buildFiltroMunicipio(),
                const SizedBox(width: 8),
                _buildFiltroPraia(),
              ],
            ),
            const SizedBox(height: 16),
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
      ),
    );
  }

  Widget _buildLinhaStatus(String asset, String label, int valor, double percentual, Color cor, {bool isPng = false}) {
    return Row(
      children: [
        Image.asset(
          'assets/images/$asset',
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        const Spacer(),
        Text("$valor", style: TextStyle(fontSize: 10, color: cor)),
        const SizedBox(width: 4),
        Text("${percentual.toStringAsFixed(1)}%", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: cor)),
      ],
    );
  }

  Widget _buildTotalCard() => Expanded(
        flex: 3,
        child: Card(
          elevation: 7,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Praias monitoradas", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("$totalPraias", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      );

  Widget _buildStatusCard(Map<String, double> dataMap, double percentualPropria, double percentualImpropria) {
    return Expanded(
      flex: 6,
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLinhaStatus('propria.png', 'Própria para banho', praiasProprias, percentualPropria, Colors.green, isPng: true),
                    const SizedBox(height: 15),
                    _buildLinhaStatus('impropria.png', 'Imprópria para banho', praiasImproprias, percentualImpropria, Colors.red, isPng: true),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: PieChart(
                    dataMap: dataMap,
                    chartType: ChartType.ring,
                    baseChartColor: Colors.grey.shade300,
                    colorList: [Colors.green, Colors.red],
                    legendOptions: const LegendOptions(showLegends: false),
                    chartValuesOptions: const ChartValuesOptions(showChartValues: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltroClassificacao() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Exibir por", style: TextStyle(fontSize: 12)),
            PopupMenuButton<String>(
              onSelected: _toggleClassificacao,
              itemBuilder: (context) => [
                _popupItem('Selecionar tudo', classificacoesSelecionadas.length == 2),
                _popupItem('Próprias', classificacoesSelecionadas.contains('Próprias')),
                _popupItem('Impróprias', classificacoesSelecionadas.contains('Impróprias')),
              ],
              child: _popupButton(_getClassificacaoLabel()),
            ),
          ],
        ),
      );

  Widget _buildFiltroMunicipio() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Filtrar por", style: TextStyle(fontSize: 12)),
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() => municipioSelecionado = value);
                if (value != 'Todos') _moverMapaParaMunicipio(value);
              },
              itemBuilder: (context) => municipios.map((m) => PopupMenuItem<String>(value: m, child: Text(m))).toList(),
              child: _popupButton(municipioSelecionado),
            ),
          ],
        ),
      );

  Widget _buildFiltroPraia() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Praia", style: TextStyle(fontSize: 12)),
            _popupButton("Praia"),
          ],
        ),
      );

  Widget _popupButton(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.arrow_drop_down),
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
