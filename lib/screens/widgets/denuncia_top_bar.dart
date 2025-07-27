/// DENUNCIA_TOP_BAR
///
/// Responsável por: Barra de navegação superior para fluxo de denúncias
/// com indicadores visuais de progresso e estados habilitado/desabilitado.
/// Utilizado em: Sistema de denúncias para navegação entre etapas.

import 'package:flutter/material.dart';

/// Widget DenunciaTopBar
///
/// Descrição: Barra horizontal com abas clicáveis, indicador de seleção
/// e controle de habilitação baseado no progresso do fluxo.
class DenunciaTopBar extends StatelessWidget {
  final List<String> opcoes;                    // Lista de nomes das abas
  final int selectedIndex;                      // Índice da aba selecionada
  final bool Function(int) podeIrParaAba;       // Função que determina se aba está habilitada
  final Function(int) onSelecionar;             // Callback ao selecionar aba

  const DenunciaTopBar({
    super.key,
    required this.opcoes,
    required this.selectedIndex,
    required this.podeIrParaAba,
    required this.onSelecionar,
  });

  /// BUILD
  ///
  /// Descrição: Constrói barra horizontal com abas e indicadores visuais.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Container com Row de abas
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8), // Padding vertical
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribui abas uniformemente
        children: List.generate(opcoes.length, (index) {
          // Estados da aba atual
          final isSelected = index == selectedIndex;  // Se está selecionada
          final isEnabled = podeIrParaAba(index);     // Se está habilitada

          return GestureDetector(
            onTap: () => onSelecionar(index),  // Callback de seleção
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Texto da aba com cor baseada no estado
                Text(
                  opcoes[index],
                  style: TextStyle(
                    fontSize: 14,
                    // Cor condicional baseada no estado
                    color: isSelected
                        ? Colors.blue[900]      // Azul escuro se selecionada
                        : isEnabled
                            ? Colors.grey[700]  // Cinza escuro se habilitada
                            : Colors.grey[400], // Cinza claro se desabilitada
                  ),
                ),
                const SizedBox(height: 4), // Espaço entre texto e indicador
                // Indicador visual de seleção
                Container(
                  height: 3,                    // Altura do indicador
                  width: 60,                    // Largura fixa
                  decoration: BoxDecoration(
                    // Cor: azul se selecionada, transparente caso contrário
                    color: isSelected ? Colors.blue[900] : Colors.transparent,
                    borderRadius: BorderRadius.circular(3), // Bordas arredondadas
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Fim da classe DenunciaTopBar
  // 
  // Barra de navegação com:
  // 
  // 📊 INDICADORES VISUAIS:
  // - Texto com cores baseadas no estado
  // - Indicador inferior para aba selecionada
  // - Estados: selecionada, habilitada, desabilitada
  // - Cores semânticas para feedback
  // 
  // 🎯 CONTROLE DE FLUXO:
  // - Função podeIrParaAba() controla habilitação
  // - Callback onSelecionar() para mudança de aba
  // - Navegação condicional baseada no progresso
  // - Prevenção de pulos de etapas
  // 
  // 🎨 LAYOUT:
  // - Row com distribuição uniforme (spaceAround)
  // - Abas responsivas ao conteúdo
  // - Indicador visual consistente
  // - Padding vertical para toque confortável
}
