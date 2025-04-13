import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AbaLocalizacao extends StatefulWidget {
  const AbaLocalizacao({super.key});

  @override
  State<AbaLocalizacao> createState() => _AbaLocalizacaoState();
}

class _AbaLocalizacaoState extends State<AbaLocalizacao> {
  late GoogleMapController _mapController;
  LatLng? _posicaoAtual;

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
  }

  Future<void> _obterLocalizacaoAtual() async {
    LocationPermission permissao = await Geolocator.requestPermission();

    if (permissao == LocationPermission.deniedForever) {
      return;
    }

    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _posicaoAtual = LatLng(posicao.latitude, posicao.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _posicaoAtual == null
        ? const Center(child: CircularProgressIndicator())
        : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _posicaoAtual!,
              zoom: 16,
            ),
            onMapCreated: (controller) => _mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          );
  }
}
