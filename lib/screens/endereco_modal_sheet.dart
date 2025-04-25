import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kGoogleApiKey = "AIzaSyD-XTfAdL3WxwtBeKfvPhiu1m3niVn1CaM";

class EnderecoModalSheet extends StatefulWidget {
  const EnderecoModalSheet({super.key});

  @override
  State<EnderecoModalSheet> createState() => _EnderecoModalSheetState();
}

class _EnderecoModalSheetState extends State<EnderecoModalSheet> {
  final TextEditingController _controller = TextEditingController();
  late GooglePlace _googlePlace;
  List<AutocompletePrediction> _predictions = [];
  Timer? _debounce;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _googlePlace = GooglePlace(kGoogleApiKey);
  }

  void _buscarComDebounce(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _buscar(value);
    });
  }

  void _buscar(String input) async {
    if (input.isEmpty) {
      setState(() => _predictions = []);
      return;
    }

    setState(() => _carregando = true);

    var result = await _googlePlace.autocomplete.get(
      input,
      language: 'pt',
      components: [Component('country', 'br')],
    );

    if (result != null && result.predictions != null) {
      setState(() => _predictions = result.predictions!);
    } else {
      debugPrint("Erro ou sem resultados");
    }

    setState(() => _carregando = false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
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
          const Text(
            "Pesquisar",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            onChanged: _buscarComDebounce,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Digite um endereço...",
              suffixIcon: _carregando
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _predictions.isEmpty && !_carregando
                ? const Center(child: Text("Nenhum resultado"))
                : ListView.builder(
                    itemCount: _predictions.length,
                    itemBuilder: (context, index) {
                      final p = _predictions[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        title: Text(p.structuredFormatting?.mainText ?? ''),
                        subtitle: Text(p.structuredFormatting?.secondaryText ?? ''),
                        onTap: () async {
                          var details = await _googlePlace.details.get(p.placeId!);

                          if (details == null ||
                              details.result == null ||
                              details.result!.geometry == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro ao obter detalhes do local.')),
                            );
                            return;
                          }

                          final loc = details.result!.geometry!.location!;
                          _controller.clear();
                          setState(() => _predictions = []);

                          Navigator.pop(context, {
                            'latLng': LatLng(loc.lat!, loc.lng!),
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
