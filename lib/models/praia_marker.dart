/// PRAIA_MARKER
///
/// Responsável por: Wrapper para marcadores de praia no mapa com classificação
/// de balneabilidade associada.
/// Utilizado em: Sistema de balneabilidade para exibir marcadores no mapa.

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Classe PraiaMarker
///
/// Descrição: Combina um marcador do Google Maps com informação de
/// classificação da qualidade da água.
class PraiaMarker {
  final Marker marker;          // Marcador do Google Maps
  final String classificacao;   // "Próprias" ou "Impróprias"

  /// CONSTRUTOR
  ///
  /// Descrição: Cria wrapper de marcador com classificação associada.
  /// Parâmetros:
  /// - marker: Marker do Google Maps com posição e ícone
  /// - classificacao: Status da qualidade da água
  ///
  /// Permite associar dados de balneabilidade ao marcador visual.
  PraiaMarker({
    required this.marker,
    required this.classificacao,
  });

  // Fim da classe PraiaMarker
  // 
  // Wrapper para marcador de praia com:
  // 
  // 🗺️ INTEGRAÇÃO MAPA:
  // - Marker do Google Maps
  // - Posição geográfica
  // - Ícone customizado baseado na classificação
  // - InfoWindow com informações da praia
  // 
  // 💧 CLASSIFICAÇÃO:
  // - Status da qualidade da água
  // - "Próprias" (seguro para banho)
  // - "Impróprias" (não recomendado)
  // - Cores diferenciadas no mapa
  // 
  // 🔧 ESTRUTURA:
  // - Classe simples de wrapper
  // - Campos imutáveis (final)
  // - Associação direta marker + dados
  // - Facilita filtragem e exibição
}
