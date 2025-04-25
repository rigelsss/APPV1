import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kGoogleApiKey = "AIzaSyD-XTfAdL3WxwtBeKfvPhiu1m3niVn1CaM";

class BuscarEnderecoPage extends StatelessWidget {
  const BuscarEnderecoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar Endereço")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final Prediction? p = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: kGoogleApiKey,
                  mode: Mode.overlay,
                  language: "pt",
                  components: [Component(Component.country, "br")],
                );

                if (p != null) {
                  final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
                  final detail = await places.getDetailsByPlaceId(p.placeId!);
                  final lat = detail.result.geometry!.location.lat;
                  final lng = detail.result.geometry!.location.lng;

                  Navigator.pop(context, {
                    'endereco': p.description!,
                    'latLng': LatLng(lat, lng),
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 12),
                    Text(
                      "Digite um endereço...",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
