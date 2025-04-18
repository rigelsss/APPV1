import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

class PraiasPage extends StatefulWidget {
  const PraiasPage({super.key});

  @override
  State<PraiasPage> createState() => _PraiasPageState();
}

class _PraiasPageState extends State<PraiasPage> {
  final int totalPraias = 62;
  final int praiasProprias = 58;
  final int praiasImproprias = 4;

  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(-7.1202, -34.8802);

  List<String> classificacoesSelecionadas = ['Próprias', 'Impróprias'];
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

  void _toggleClassificacao(String item) {
    setState(() {
      if (item == 'Selecionar tudo') {
        if (classificacoesSelecionadas.length < 2) {
          classificacoesSelecionadas = ['Próprias', 'Impróprias'];
        } else {
          classificacoesSelecionadas.clear();
        }
      } else {
        if (classificacoesSelecionadas.contains(item)) {
          classificacoesSelecionadas.remove(item);
        } else {
          classificacoesSelecionadas.add(item);
        }
      }
    });
  }

  String _getClassificacaoLabel() {
    if (classificacoesSelecionadas.length == 2) {
      return 'Selecionar tudo';
    } else if (classificacoesSelecionadas.length == 1) {
      return classificacoesSelecionadas.first;
    } else {
      return 'Classificação';
    }
  }

  void _moverMapaParaMunicipio(String municipio) {
    if (coordenadasMunicipios.containsKey(municipio)) {
      final destino = coordenadasMunicipios[municipio]!;
      mapController.animateCamera(CameraUpdate.newLatLngZoom(destino, 13));
    }
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
            const Text(
              "Balneabilidade",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Cards
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
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
                            Text(
                              "$totalPraias",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: Card(
                      elevation: 7,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/images/propria.svg', width: 12, height: 12),
                                      const SizedBox(width: 4),
                                      const Text("Própria para banho", style: TextStyle(fontSize: 10)),
                                      const Spacer(),
                                      Text(
                                        "$praiasProprias",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.green),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${percentualPropria.toStringAsFixed(1)}%",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.green.shade700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      SvgPicture.asset('assets/images/impropria.svg', width: 12, height: 12),
                                      const SizedBox(width: 6),
                                      const Text("Imprópria para banho", style: TextStyle(fontSize: 10)),
                                      const Spacer(),
                                      Text(
                                        "$praiasImproprias",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.red),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${percentualImpropria.toStringAsFixed(1)}%",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.red.shade700),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filtros
            Row(
              children: [
                // EXIBIR POR
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Exibir por", style: TextStyle(fontSize: 12)),
                      PopupMenuButton<String>(
                        onSelected: _toggleClassificacao,
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'Selecionar tudo',
                            child: Row(
                              children: [
                                Checkbox(
                                  value: classificacoesSelecionadas.length == 2,
                                  onChanged: (_) => Navigator.pop(context, 'Selecionar tudo'),
                                ),
                                const Flexible(child: Text('Selecionar tudo')),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Próprias',
                            child: Row(
                              children: [
                                Checkbox(
                                  value: classificacoesSelecionadas.contains('Próprias'),
                                  onChanged: (_) => Navigator.pop(context, 'Próprias'),
                                ),
                                const Flexible(child: Text('Próprias')),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Impróprias',
                            child: Row(
                              children: [
                                Checkbox(
                                  value: classificacoesSelecionadas.contains('Impróprias'),
                                  onChanged: (_) => Navigator.pop(context, 'Impróprias'),
                                ),
                                const Flexible(child: Text('Impróprias')),
                              ],
                            ),
                          ),
                        ],
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 40),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _getClassificacaoLabel(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // MUNICÍPIO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Filtrar por", style: TextStyle(fontSize: 12)),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() => municipioSelecionado = value);
                          if (value != 'Todos') {
                            _moverMapaParaMunicipio(value);
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return municipios.map((String m) {
                            return PopupMenuItem<String>(
                              value: m,
                              child: Text(m),
                            );
                          }).toList();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text(municipioSelecionado, overflow: TextOverflow.ellipsis)),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // PRAIA
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Praia", style: TextStyle(fontSize: 12)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Praia"),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // MAPA
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 13,
                  ),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
