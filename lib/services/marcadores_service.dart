/// MARCADORES_SERVICE
///
/// Responsável por: Geração de marcadores para o mapa com ícones diferenciados
/// por classificação e cálculo de posição para overlays.
/// Utilizado em: Sistema de balneabilidade para exibir estações no mapa.

import 'package:flutter/rendering.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/praia_marker.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';

/// Classe MarcadoresService
///
/// Descrição: Serviço estático para geração de marcadores do Google Maps
/// com ícones personalizados e interação avançada.
class MarcadoresService {
  /// GERARMARCADORES
  ///
  /// Descrição: Gera lista de marcadores com ícones baseados na classificação
  /// e cálculo de offset para posicionamento de overlays.
  /// Parâmetros:
  /// - estacoes: Lista de estações de monitoramento
  /// - iconePropria: Ícone para praias próprias (verde)
  /// - iconeImpropria: Ícone para praias impróprias (vermelho)
  /// - getScreenCoordinate: Função para converter LatLng em coordenada de tela
  /// - getMapOffset: Função para obter offset do mapa
  /// - onTapEstacao: Callback executado ao tocar no marcador
  /// Retorno: List<PraiaMarker> com marcadores configurados
  static List<PraiaMarker> gerarMarcadores({
    required List<EstacaoMonitoramento> estacoes,
    required BitmapDescriptor iconePropria,     // Ícone verde
    required BitmapDescriptor iconeImpropria,   // Ícone vermelho
    required Future<ScreenCoordinate> Function(LatLng) getScreenCoordinate,
    required Offset Function() getMapOffset,
    required Function(EstacaoMonitoramento estacao, Offset position) onTapEstacao,
  }) {
    final List<PraiaMarker> marcadores = [];  // Lista de marcadores resultante

    // Itera sobre todas as estações para criar marcadores
    for (var est in estacoes) {
      // Validação de coordenadas válidas
      if (est.coordenadas.latitude.isNaN || est.coordenadas.longitude.isNaN) {
        print('❌ Coordenadas inválidas para estação ${est.nome}');
        continue;  // Pula estação com coordenadas inválidas
      }

      // Seleciona ícone baseado na classificação da água
      final icon = est.classificacao == 'Próprias' ? iconePropria : iconeImpropria;

      // Cria marcador do Google Maps
      final marker = Marker(
        markerId: MarkerId(est.codigo),  // ID único baseado no código
        position: est.coordenadas,       // Posição geográfica
        icon: icon,                      // Ícone baseado na classificação
        // Callback de toque com cálculo de offset para overlay
        onTap: () async {
          try {
            /// Cálculo de Posição para Overlay
            ///
            /// Converte coordenadas geográficas em posição de tela
            /// para posicionar overlay de informações sobre o marcador.
            
            // Converte LatLng para coordenada de tela
            final screenCoord = await getScreenCoordinate(est.coordenadas);
            // Obtém offset do widget do mapa
            final Offset mapOffset = getMapOffset();

            // Calcula posição relativa ao mapa
            final offset = Offset(
              screenCoord.x.toDouble() - mapOffset.dx,  // Posição X relativa
              screenCoord.y.toDouble() - mapOffset.dy,  // Posição Y relativa
            );

            // Executa callback com estação e posição calculada
            onTapEstacao(est, offset);
          } catch (e) {
            // Log de erro se cálculo falhar
            print("❌ Erro ao calcular offset do marcador ${est.codigo}: $e");
          }
        },
      );

      // Adiciona wrapper PraiaMarker à lista
      marcadores.add(PraiaMarker(
        marker: marker,                // Marcador do Google Maps
        classificacao: est.classificacao,  // Classificação para filtragem
      ));
    }

    return marcadores;  // Retorna lista completa de marcadores
  }

  // Fim da classe MarcadoresService
  // 
  // Serviço de geração de marcadores com:
  // 
  // 🗺️ MARCADORES PERSONALIZADOS:
  // - Ícones diferenciados por classificação
  // - Verde: praias próprias (seguras)
  // - Vermelho: praias impróprias (não recomendadas)
  // - ID único baseado no código da estação
  // 
  // 📱 INTERAÇÃO AVANÇADA:
  // - Cálculo de offset para overlays
  // - Conversão LatLng → coordenada de tela
  // - Posição relativa ao widget do mapa
  // - Callback com dados da estação e posição
  // 
  // ⚙️ TRATAMENTO DE ERROS:
  // - Validação de coordenadas válidas
  // - Skip de estações com dados inválidos
  // - Try-catch para cálculos de posição
  // - Logs para debug
  // 
  // 🔄 WRAPPER PRAIA_MARKER:
  // - Combina Marker + classificação
  // - Facilita filtragem posterior
  // - Mantém dados associados
  // - Estrutura para sistema de balneabilidade
}
