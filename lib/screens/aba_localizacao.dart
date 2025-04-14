import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sudema_app/screens/endereco_modal_sheet.dart';

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

  void _confirmarEndereco() {
    print('Endereço confirmado: $_endereco');
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
        _confirmando = true;
      });
    }
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
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      controller: _buscaController,
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmando
                        ? _confirmarEndereco
                        : _abrirBuscaModalEstilizado,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2A2F8C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
