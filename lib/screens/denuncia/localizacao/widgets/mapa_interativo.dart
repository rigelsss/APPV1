/// MAPA_INTERATIVO
///
/// Responsável por: Widget do Google Maps com funcionalidades de localização e geocodificação.
/// Utilizado em: Etapa de localização das denúncias ambientais.
/// 
/// Este widget oferece:
/// - Mapa interativo do Google Maps
/// - Obtenção automática da localização atual via GPS
/// - Geocodificação reversa para converter coordenadas em endereço
/// - Debounce para otimizar requisições durante movimento do mapa
/// - Parsing detalhado de endereços (estado, cidade, bairro, logradouro)
/// - Integração com modelo global de dados da denúncia

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MapaInterativo extends StatefulWidget {
  final LatLng? posicaoAtual;                                                      // Posição atual do mapa
  final void Function(LatLng novaPosicao, String enderecoFormatado) onAtualizarPosicao; // Callback para atualizações
  final void Function(GoogleMapController)? onMapCreatedExternal;                  // Callback quando mapa é criado
  final double paddingBottom;                                                      // Padding inferior para painel

  const MapaInterativo({
    super.key,
    required this.posicaoAtual,
    required this.onAtualizarPosicao,
    this.onMapCreatedExternal,
    this.paddingBottom = 0,
  });

  @override
  State<MapaInterativo> createState() => _MapaInterativoState();
}

class _MapaInterativoState extends State<MapaInterativo> {
  // Controles do mapa
  late GoogleMapController _mapController;  // Controlador do Google Maps
  Timer? _debounce;                        // Timer para debounce de requisições
  LatLng? _posicaoCentral;                 // Posição central atual do mapa
  
  // Estados de controle
  bool _usuarioMovendoMapa = false;        // Flag para detectar movimento do usuário
  bool _jaCentralizouInicial = false;      // Flag para centralizar apenas uma vez

  // Chave da API do Google para geocodificação
  // TODO: Mover para variáveis de ambiente por segurança
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

    await _buscarEnderecoGoogle(latLng, atualizarCallback: false);

    if (!_jaCentralizouInicial) {
      _jaCentralizouInicial = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: latLng,
                zoom: 17,
              ),
            ),
          );
        }
      });
    }
  }
  
  Future<void> _buscarEnderecoGoogle(LatLng posicao, {bool atualizarCallback = false}) async {
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

        if (atualizarCallback) {
          widget.onAtualizarPosicao(posicao, enderecoFormatado);
        }
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
        target: _posicaoCentral!,
        zoom: 17,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        widget.onMapCreatedExternal?.call(controller);
      },
      padding: EdgeInsets.only(bottom: widget.paddingBottom),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onCameraMoveStarted: () {
        _usuarioMovendoMapa = true;
      },
      onCameraIdle: () async {
        if (!_usuarioMovendoMapa) return;
        _usuarioMovendoMapa = false;

        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () async {
          LatLngBounds bounds = await _mapController.getVisibleRegion();
          final centerLat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
          final centerLng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
          final center = LatLng(centerLat, centerLng);

          setState(() {
            _posicaoCentral = center;
          });

          await _buscarEnderecoGoogle(center, atualizarCallback: true);
        });
      },
    );
  }
}
