/// PERFIL_INFO_LABEL
///
/// Responsável por: Widget reutilizável para exibir informações do usuário
/// com label e valor em layout horizontal organizado.
/// Utilizado em: PerfilInfoCard para exibir e-mail, telefone e CPF.

import 'package:flutter/material.dart';

/// Widget LabeledInfoItem
///
/// Descrição: Row com label fixo à esquerda e valor expansível à direita,
/// com estilos diferenciados para hierarquia visual.
class LabeledInfoItem extends StatelessWidget {
  final String label;  // Label da informação (ex: "E-mail:", "Telefone:")
  final String value;  // Valor da informação (ex: email@exemplo.com)

  const LabeledInfoItem({required this.label, required this.value, super.key});

  /// BUILD
  ///
  /// Descrição: Constrói layout horizontal com label fixo e valor expansível.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Padding com Row organizado
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0),  // Espaçamento vertical mínimo
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,  // Alinha ao topo
        children: [
          // Label com largura fixa para alinhamento
          SizedBox(
            width: 80,  // Largura fixa para alinhar todos os labels
            child: Text(
              '$label:',  // Adiciona dois pontos ao label
              style: const TextStyle(
                color: Colors.black,     // Preto padrão
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 0),  // Sem espaço adicional
          // Valor com largura expansível
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,        // Preto mais suave
                fontWeight: FontWeight.w600,  // Peso maior para destaque
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fim da classe LabeledInfoItem
  // 
  // Widget para informações do usuário com:
  // - Label com largura fixa (80px) para alinhamento
  // - Valor com peso de fonte maior para destaque
  // - Layout horizontal responsivo
  // - Espaçamento vertical mínimo
  // - Cores diferenciadas para hierarquia visual
}
