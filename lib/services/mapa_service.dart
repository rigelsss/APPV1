import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/services/estacoes_service.dart';

class MapaService {
  static LatLng calcularCentroMunicipio(List<EstacaoMonitoramento> lista) {
    final latSum = lista.map((e) => e.coordenadas.latitude).reduce((a, b) => a + b);
    final lngSum = lista.map((e) => e.coordenadas.longitude).reduce((a, b) => a + b);
    return LatLng(latSum / lista.length, lngSum / lista.length);
  }

  static Future<void> moverMapaParaMunicipio({
    required GoogleMapController controller,
    required List<EstacaoMonitoramento> estacoes,
    required String municipio,
    required Function() onComplete,
  }) async {
    final lista = estacoes.where((e) => e.municipio == municipio).toList();
    if (lista.isNotEmpty) {
      final destino = calcularCentroMunicipio(lista);
      await controller.animateCamera(CameraUpdate.newLatLngZoom(destino, 12.5));
    }
    onComplete();
  }
}
