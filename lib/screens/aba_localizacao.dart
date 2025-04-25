import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:http/http.dart' as http;
import 'package:sudema_app/screens/endereco_modal_sheet.dart';
import '../models/denuncia_data.dart';

class AbaLocalizacao extends StatefulWidget {
  final VoidCallback onEnderecoConfirmado;
  const AbaLocalizacao({super.key, required this.onEnderecoConfirmado});

  @override
  State<AbaLocalizacao> createState() => _AbaLocalizacaoState();
}

class _AbaLocalizacaoState extends State<AbaLocalizacao> {
  late GoogleMapController _mapController;
  LatLng? _posicaoAtual;
  String _endereco = 'Carregando endereço...';
  String _tipoEndereco = '';
  String _placemarkInfo = '';
  Timer? _debounce;

  final TextEditingController _buscaController = TextEditingController();
  static const String _googleApiKey = 'AIzaSyD-XTfAdL3WxwtBeKfvPhiu1m3niVn1CaM';
  static const bool devMode = true;

  @override
  void initState() {
    super.initState();
    DenunciaData().enderecoConfirmado = false;

    _obterLocalizacaoAtual();
  }

  Future<void> _obterLocalizacaoAtual() async {
    final permissao = await Geolocator.requestPermission();
    if (permissao == LocationPermission.denied || permissao == LocationPermission.deniedForever) return;

    final posicao = await Geolocator.getCurrentPosition();
    setState(() {
      _posicaoAtual = LatLng(posicao.latitude, posicao.longitude);
    });
    _buscarEnderecoGoogle(_posicaoAtual!);
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

        final endereco = selecionado['formatted_address'];
        final tipo = selecionado['types'].join(', ');

        setState(() {
          _endereco = endereco;
          _tipoEndereco = tipo;
          _buscaController.text = endereco;
        });

        DenunciaData().localizacao = posicao;
        DenunciaData().endereco = endereco;

        final placemarks = await geo.placemarkFromCoordinates(
          posicao.latitude,
          posicao.longitude,
          localeIdentifier: "pt_BR",
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          setState(() {
            _placemarkInfo = '${p.street}, ${p.subLocality}, ${p.locality}, ${p.postalCode}';
          });
        }

        if (devMode) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Google: $tipo\n📌 $_placemarkInfo'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else {
        throw Exception('Nenhum resultado');
      }
    } catch (e) {
      setState(() {
        _endereco = 'Endereço não encontrado';
        _tipoEndereco = '';
        _placemarkInfo = '';
        _buscaController.text = _endereco;
      });
      DenunciaData().endereco = 'Endereço não encontrado';
    }
  }

  void _confirmarEndereco() {
    print('Endereço confirmado: $_endereco');

    DenunciaData().localizacao = _posicaoAtual;
    DenunciaData().endereco = _endereco;
    DenunciaData().enderecoConfirmado = true;

    widget.onEnderecoConfirmado();
  }

  Future<void> _abrirBuscaModalEstilizado() async {
    final resultado = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EnderecoModalSheet(),
    );

    if (resultado != null && resultado['latLng'] != null) {
      LatLng destino = resultado['latLng'];
      String enderecoSelecionado = resultado['endereco'];

      _mapController.animateCamera(CameraUpdate.newLatLng(destino));

      setState(() {
        _posicaoAtual = destino;
        _endereco = enderecoSelecionado;
        _buscaController.text = enderecoSelecionado;
      });

      DenunciaData().localizacao = _posicaoAtual;
      DenunciaData().endereco = _endereco;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enderecoValido = DenunciaData().endereco != null &&
        DenunciaData().endereco!.isNotEmpty &&
        DenunciaData().endereco != 'Endereço não encontrado';

    return Stack(
      children: [
        if (_posicaoAtual != null)
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _posicaoAtual!,
              zoom: 17,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraIdle: () async {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () async {
                LatLngBounds bounds = await _mapController.getVisibleRegion();
                final centerLat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
                final centerLng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
                final center = LatLng(centerLat, centerLng);

                setState(() {
                  _posicaoAtual = center;
                });

                _buscarEnderecoGoogle(center);
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          )
        else
          const Center(child: CircularProgressIndicator()),

        const Center(
          child: Icon(Icons.location_pin, size: 40, color: Colors.red),
        ),

        if (devMode && _posicaoAtual != null)
          Positioned(
            top: 20,
            left: 10,
            right: 10,
            child: Card(
              color: Colors.white.withOpacity(0.9),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DefaultTextStyle(
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📍 Lat: ${_posicaoAtual!.latitude.toStringAsFixed(6)}'),
                      Text('📍 Lng: ${_posicaoAtual!.longitude.toStringAsFixed(6)}'),
                      Text('🧾 Tipo: $_tipoEndereco'),
                      Text('🏠 Google: $_endereco'),
                      Text('📌 Placemark: $_placemarkInfo'),
                    ],
                  ),
                ),
              ),
            ),
          ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Localização da Infração',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Arraste o mapa para mover o marcador',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: _abrirBuscaModalEstilizado,
                  child: AbsorbPointer(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextField(
                        controller: _buscaController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Pesquisar',
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          suffixIcon: const Icon(Icons.search, color: Colors.grey),
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
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: enderecoValido ? _confirmarEndereco : _abrirBuscaModalEstilizado,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2F8C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      enderecoValido ? 'Confirmar endereço' : 'Pesquisar',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
