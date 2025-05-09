import 'package:flutter/rendering.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/praia_marker.dart';
import 'package:sudema_app/services/estacoes_service.dart';

class MarcadoresService {
  static List<PraiaMarker> gerarMarcadores({
    required List<EstacaoMonitoramento> estacoes,
    required BitmapDescriptor iconePropria,
    required BitmapDescriptor iconeImpropria,
    required Future<ScreenCoordinate> Function(LatLng) getScreenCoordinate,
    required Offset Function() getMapOffset,
    required Function(EstacaoMonitoramento estacao, Offset position) onTapEstacao,
  }) {
    final List<PraiaMarker> marcadores = [];

    for (var est in estacoes) {
      final icon = est.classificacao == 'Próprias' ? iconePropria : iconeImpropria;

      final marker = Marker(
        markerId: MarkerId(est.codigo),
        position: est.coordenadas,
        icon: icon,
        onTap: () async {
          final screenCoord = await getScreenCoordinate(est.coordenadas);
          final Offset mapOffset = getMapOffset(); 

          final offset = Offset(
            screenCoord.x.toDouble() - mapOffset.dx,
            screenCoord.y.toDouble() - mapOffset.dy,
          );

          onTapEstacao(est, offset);
        },
      );

      marcadores.add(PraiaMarker(marker: marker, classificacao: est.classificacao));
    }

    return marcadores;
  }
}
