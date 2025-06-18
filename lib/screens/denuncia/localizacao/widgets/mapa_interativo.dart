import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MapaInterativo extends StatefulWidget {
  final LatLng? posicaoAtual;
  final void Function(LatLng novaPosicao, String enderecoFormatado) onAtualizarPosicao;
  final void Function(GoogleMapController)? onMapCreatedExternal;

  const MapaInterativo({
    super.key,
    required this.posicaoAtual,
    required this.onAtualizarPosicao,
    this.onMapCreatedExternal,
  });

  @override
  State<MapaInterativo> createState() => _MapaInterativoState();
}

class _MapaInterativoState extends State<MapaInterativo> {
  late GoogleMapController _mapController;
  Timer? _debounce;
  LatLng? _posicaoCentral;

  LatLng _ajustarCameraParaCima(LatLng original) {
    const deslocamentoLat = 0.0012;
    return LatLng(original.latitude + deslocamentoLat, original.longitude);
  }

  static const String _googleApiKey = 'AIzaSyD-XTfAdL3WxwtBeKfvPhiu1m3niVn1CaM';

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
  }

  Future<void> _obterLocalizacaoAtual() async {
    final permissao = await Geolocator.requestPermission();
    if (permissao == LocationPermission.denied || permissao == LocationPermission.deniedForever) return;

    final posicao = await Geolocator.getCurrentPosition();
    final latLng = LatLng(posicao.latitude, posicao.longitude);

    setState(() {
      _posicaoCentral = latLng;
    });

    await _buscarEnderecoGoogle(latLng);
  }

  Future<void> _buscarEnderecoGoogle(LatLng posicao) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${posicao.latitude},${posicao.longitude}&key=$_googleApiKey&language=pt-BR',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final results = data['results'] as List;

        Map<String, dynamic> selecionado = results.firstWhere(
          (r) => r['types'].contains('street_address'),
          orElse: () => results.firstWhere(
            (r) => r['types'].contains('route'),
            orElse: () => results[0],
          ),
        );

        final enderecoFormatado = selecionado['formatted_address'];

        final dados = DenunciaData();
        dados.latitude = double.parse(posicao.latitude.toStringAsFixed(8));
        dados.longitude = double.parse(posicao.longitude.toStringAsFixed(8));
        dados.endereco = enderecoFormatado;

        final placemarks = await geo.placemarkFromCoordinates(
          posicao.latitude,
          posicao.longitude,
          localeIdentifier: "pt_BR",
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;

          dados.estado = p.administrativeArea ?? 'Desconhecido';
          dados.bairro = p.subLocality ?? 'Desconhecido';
          dados.municipio = (p.locality?.isNotEmpty == true
              ? p.locality
              : p.subAdministrativeArea) ?? 'Desconhecido';

          final RegExp numeroRegex = RegExp(r',\s*(\d{1,5})');
          final match = numeroRegex.firstMatch(enderecoFormatado);
          final numero = match?.group(1);

          dados.logradouro = (p.street != null && p.street!.isNotEmpty)
              ? (numero != null ? '${p.street}, $numero' : p.street!)
              : enderecoFormatado;
        }

        widget.onAtualizarPosicao(posicao, enderecoFormatado);
      } else {
        throw Exception('Nenhum resultado');
      }
    } catch (e) {
      debugPrint('Erro ao buscar endereço: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_posicaoCentral == null) return const SizedBox.shrink();

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _ajustarCameraParaCima(_posicaoCentral!),
        zoom: 17,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        widget.onMapCreatedExternal?.call(controller);
      },
      onCameraIdle: () async {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () async {
          LatLngBounds bounds = await _mapController.getVisibleRegion();
          final centerLat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
          final centerLng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
          final center = LatLng(centerLat, centerLng);

          setState(() {
            _posicaoCentral = center;
          });

          _buscarEnderecoGoogle(center);
        });
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }
}
