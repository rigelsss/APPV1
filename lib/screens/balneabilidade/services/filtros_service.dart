/// FILTROS_SERVICE
///
/// Responsável por: Aplicar filtros aos marcadores do mapa de balneabilidade baseado em
/// município, trecho, classificação e nível de zoom.
/// Utilizado em: Controller de balneabilidade para determinar quais marcadores exibir.

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';
import 'package:sudema_app/models/praia_marker.dart';

class FiltrosService {

  /// FILTRAR
  ///
  /// Descrição: Aplica todos os filtros ativos e retorna conjunto de marcadores visíveis.
  /// Parâmetros:
  /// - todosMarcadores: Lista completa de marcadores gerados
  /// - estacoes: Lista de estações para consulta de dados
  /// - municipioSelecionado: Município filtrado (vazio = todos)
  /// - trechoSelecionado: Trecho filtrado (vazio = todos)
  /// - classificacoesSelecionadas: Lista de classificações permitidas
  /// - currentZoom: Nível de zoom atual do mapa
  /// - minZoomToShowMarkers: Zoom mínimo para exibir marcadores
  /// Retorno: Set<Marker> - marcadores que passaram em todos os filtros
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

    // Filtro de zoom: não exibe marcadores em zoom muito baixo (performance)
    if (currentZoom < minZoomToShowMarkers) return visiveis;

    // Itera sobre todos os marcadores aplicando filtros
    for (var pm in todosMarcadores) {
      // Encontra estação correspondente ao marcador
      final est = estacoes.firstWhere(
        (e) => e.codigo == pm.marker.markerId.value,
        orElse: () => EstacaoMonitoramento.vazio(), // Fallback se não encontrar
      );

      // Filtro 1: Município (passa se vazio, "Todos" ou coincide)
      final matchMunicipio = municipioSelecionado.isEmpty ||
          municipioSelecionado == 'Todos' ||
          est.municipio == municipioSelecionado;

      // Filtro 2: Trecho/praia (passa se vazio, "Todos" ou coincide)
      final matchTrecho = trechoSelecionado.isEmpty ||
          trechoSelecionado == 'Todos' ||
          est.nome == trechoSelecionado;

      // Filtro 3: Classificação (deve estar na lista de selecionadas)
      final matchClassificacao = classificacoesSelecionadas.contains(pm.classificacao);

      // Adiciona marcador apenas se passou em todos os filtros
      if (matchMunicipio && matchTrecho && matchClassificacao) {
        visiveis.add(pm.marker);
      }
    }

    return visiveis;
  }
}
