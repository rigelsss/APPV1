import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kGoogleApiKey = "AIzaSyD-XTfAdL3WxwtBeKfvPhiu1m3niVn1CaM";

class EnderecoModalSheet extends StatefulWidget {
  const EnderecoModalSheet({super.key});

  @override
  State<EnderecoModalSheet> createState() => _EnderecoModalSheetState();
}

class _EnderecoModalSheetState extends State<EnderecoModalSheet> {
  final TextEditingController _controller = TextEditingController();
  List<Prediction> _resultados = [];

  final _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  void _buscar(String input) async {
    if (input.trim().isEmpty) return;

    final response = await _places.autocomplete(
      input,
      language: 'pt',
      components: [Component(Component.country, "br")],
    );

    if (response.isOkay) {
      setState(() => _resultados = response.predictions);
    } else {
      debugPrint('Erro ao buscar autocomplete: ${response.errorMessage}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: altura,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Pesquisar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: _controller,
                onChanged: _buscar,
                decoration: InputDecoration(
                  hintText: "Digite um endereço...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _resultados.length,
              itemBuilder: (context, index) {
                final p = _resultados[index];
                return ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(p.structuredFormatting?.mainText ?? ''),
                  subtitle: Text(p.structuredFormatting?.secondaryText ?? ''),
                  onTap: () async {
                    final detail = await _places.getDetailsByPlaceId(p.placeId!);
                    final lat = detail.result.geometry!.location.lat;
                    final lng = detail.result.geometry!.location.lng;

                    Navigator.pop(context, {
                      'latLng': LatLng(lat, lng),
                      'endereco': p.description,
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
