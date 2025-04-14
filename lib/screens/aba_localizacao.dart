import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class AbaLocalizacao extends StatefulWidget {
  const AbaLocalizacao({super.key});

  @override
  State<AbaLocalizacao> createState() => _AbaLocalizacaoState();
}

class _AbaLocalizacaoState extends State<AbaLocalizacao> {
  late GoogleMapController _mapController;
  LatLng? _posicaoAtual;
  String _endereco = 'Carregando endereço...';
  bool _confirmando = false;

  final TextEditingController _buscaController = TextEditingController();
  List<String> _sugestoes = [];

  static const String _apiKey = 'AIzaSyD-XTfAdL3WxwtBeKfvPhiu1m3niVn1CaM'; 

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
  }

  Future<void> _obterLocalizacaoAtual() async {
    final permissao = await Geolocator.requestPermission();
    if (permissao == LocationPermission.denied || permissao == LocationPermission.deniedForever) return;

    final posicao = await Geolocator.getCurrentPosition();
    setState(() {
      _posicaoAtual = LatLng(posicao.latitude, posicao.longitude);
    });
    _buscarEndereco(_posicaoAtual!);
  }

  Future<void> _buscarEndereco(LatLng posicao) async {
    try {
      final placemarks = await placemarkFromCoordinates(posicao.latitude, posicao.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _endereco = '${place.street}, ${place.subLocality}, ${place.locality}';
        });
      }
    } catch (e) {
      setState(() {
        _endereco = 'Endereço não encontrado';
      });
    }
  }

  Future<void> _buscarSugestoes(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_apiKey&components=country:br';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List predictions = data['predictions'];
      setState(() {
        _sugestoes = predictions.map<String>((e) => e['description'] as String).toList();
      });
    }
  }

  Future<void> _selecionarSugestao(String endereco) async {
    try {
      final locais = await locationFromAddress(endereco);
      if (locais.isNotEmpty) {
        final destino = LatLng(locais.first.latitude, locais.first.longitude);
        _mapController.animateCamera(CameraUpdate.newLatLng(destino));
        _buscarEndereco(destino);
        setState(() {
          _confirmando = true;
          _sugestoes.clear();
          _buscaController.text = endereco;
        });
      }
    } catch (e) {
      setState(() {
        _endereco = 'Endereço não encontrado';
      });
    }
  }

  void _confirmarEndereco() {
    print('Endereço confirmado: $_endereco');
  }

  @override
  Widget build(BuildContext context) {
    if (_posicaoAtual == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _posicaoAtual!,
            zoom: 17,
          ),
          onMapCreated: (controller) => _mapController = controller,
          onCameraIdle: () async {
            final posicao = await _mapController.getLatLng(
              ScreenCoordinate(
                x: MediaQuery.of(context).size.width ~/ 2,
                y: MediaQuery.of(context).size.height ~/ 2,
              ),
            );
            _buscarEndereco(posicao);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),

        const Center(
          child: Icon(Icons.location_pin, size: 40, color: Colors.red),
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
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _buscaController,
                  onChanged: _buscarSugestoes,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                ..._sugestoes.map((sugestao) => ListTile(
                      title: Text(sugestao),
                      onTap: () => _selecionarSugestao(sugestao),
                    )),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmando ? _confirmarEndereco : () => _buscarSugestoes(_buscaController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _confirmando ? 'Confirmar endereço' : 'Pesquisar',
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
