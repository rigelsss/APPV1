import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';
import 'package:sudema_app/models/praia_marker.dart';

class FiltrosService {

  static Set<Marker> filtrar({
    required List<PraiaMarker> todosMarcadores,
    required List<EstacaoMonitoramento> estacoes,
    required String municipioSelecionado,
    required String trechoSelecionado,
    required List<String> classificacoesSelecionadas,
    required double currentZoom,
    required double minZoomToShowMarkers,
  }) {
    final Set<Marker> visiveis = {};

    if (currentZoom < minZoomToShowMarkers) return visiveis;

    for (var pm in todosMarcadores) {
      final est = estacoes.firstWhere(
        (e) => e.codigo == pm.marker.markerId.value,
        orElse: () => EstacaoMonitoramento.vazio(),
      );

      final matchMunicipio = municipioSelecionado.isEmpty ||
          municipioSelecionado == 'Todos' ||
          est.municipio == municipioSelecionado;

      final matchTrecho = trechoSelecionado.isEmpty ||
          trechoSelecionado == 'Todos' ||
          est.nome == trechoSelecionado;

      final matchClassificacao = classificacoesSelecionadas.contains(pm.classificacao);

      if (matchMunicipio && matchTrecho && matchClassificacao) {
        visiveis.add(pm.marker);
      }
    }

    return visiveis;
  }
}
