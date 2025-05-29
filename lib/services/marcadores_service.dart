import 'package:flutter/rendering.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/praia_marker.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';

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
      if (est.coordenadas.latitude.isNaN || est.coordenadas.longitude.isNaN) {
        print('❌ Coordenadas inválidas para estação ${est.nome}');
        continue;
      }

      final icon = est.classificacao == 'Próprias' ? iconePropria : iconeImpropria;

      final marker = Marker(
        markerId: MarkerId(est.codigo),
        position: est.coordenadas,
        icon: icon,
        onTap: () async {
          try {
            final screenCoord = await getScreenCoordinate(est.coordenadas);
            final Offset mapOffset = getMapOffset();

            final offset = Offset(
              screenCoord.x.toDouble() - mapOffset.dx,
              screenCoord.y.toDouble() - mapOffset.dy,
            );

            onTapEstacao(est, offset);
          } catch (e) {
            print("❌ Erro ao calcular offset do marcador ${est.codigo}: $e");
          }
        },
      );

      marcadores.add(PraiaMarker(
        marker: marker,
        classificacao: est.classificacao,
      ));
    }

    return marcadores;
  }
}
