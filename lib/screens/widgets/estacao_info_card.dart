/// ESTACAO_INFO_CARD
///
/// Responsável por: Card informativo para exibir dados de estação de monitoramento
/// com classificação colorida e informações completas.
/// Utilizado em: Sistema de balneabilidade como overlay sobre marcadores do mapa.

import 'package:flutter/material.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';

/// Widget EstacaoInfoCard
///
/// Descrição: Card com elevação e bordas arredondadas exibindo dados
/// completos da estação com classificação colorida.
class EstacaoInfoCard extends StatelessWidget {
  final EstacaoMonitoramento estacao;  // Dados da estação a ser exibida

  const EstacaoInfoCard({super.key, required this.estacao});

  /// BUILD
  ///
  /// Descrição: Constrói card com informações da estação e classificação colorida.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Material com card informativo
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,                           // Sombra para destaque
      borderRadius: BorderRadius.circular(12), // Bordas arredondadas
      child: Container(
        width: 260,                           // Largura fixa do card
        padding: const EdgeInsets.all(14),   // Padding interno
        decoration: BoxDecoration(
          color: Colors.white,                // Fundo branco
          borderRadius: BorderRadius.circular(12), // Bordas consistentes
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
          children: [
            // Título: Nome da praia + município
            Text(
              '${estacao.nome} - ${estacao.municipio}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Endereço/localização
            Text(
              estacao.endereco,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Código da estação
            Text(
              'Estação: ${estacao.codigo}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // Classificação com cor semântica
            Text(
              estacao.classificacao == 'Próprias'
                  ? 'Própria para banho'      // Texto para água segura
                  : 'Imprópria para banho',   // Texto para água não recomendada
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                // Cor semântica: verde (seguro) ou vermelho (perigoso)
                color: estacao.classificacao == 'Próprias'
                    ? Colors.green   // Verde para água própria
                    : Colors.red,    // Vermelho para água imprópria
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fim da classe EstacaoInfoCard
  // 
  // Card informativo com:
  // 
  // 🏖️ INFORMAÇÕES DA PRAIA:
  // - Nome da praia + município
  // - Endereço/localização
  // - Código da estação de monitoramento
  // - Classificação da qualidade da água
  // 
  // 🎨 DESIGN:
  // - Material com elevação 6
  // - Bordas arredondadas (12px)
  // - Fundo branco com padding
  // - Largura fixa (260px)
  // 
  // 💧 CLASSIFICAÇÃO COLORIDA:
  // - Verde: "Própria para banho" (seguro)
  // - Vermelho: "Imprópria para banho" (não recomendado)
  // - Texto descritivo para usuário
  // - Cores semânticas para rápida identificação
}
