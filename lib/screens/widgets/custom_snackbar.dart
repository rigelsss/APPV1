/// CUSTOM_SNACKBAR
///
/// Responsável por: Utilitário para exibir SnackBars padronizadas com
/// cores semânticas (verde para sucesso, vermelho para erro).
/// Utilizado em: Todo o app para feedback visual consistente.

import 'package:flutter/material.dart';

/// Classe CustomSnackbar
///
/// Descrição: Classe utilitária estática para SnackBars com cores semânticas.
class CustomSnackbar {
  /// ERRO
  ///
  /// Descrição: Exibe SnackBar vermelha para mensagens de erro.
  /// Parâmetros:
  /// - context: Contexto para ScaffoldMessenger
  /// - mensagem: Texto a ser exibido
  /// Retorno: void
  static void erro(BuildContext context, String mensagem) {
    _mostrar(context, mensagem, Colors.red);  // Vermelho para erro
  }

  /// SUCESSO
  ///
  /// Descrição: Exibe SnackBar verde para mensagens de sucesso.
  /// Parâmetros:
  /// - context: Contexto para ScaffoldMessenger
  /// - mensagem: Texto a ser exibido
  /// Retorno: void
  static void sucesso(BuildContext context, String mensagem) {
    _mostrar(context, mensagem, Colors.green);  // Verde para sucesso
  }

  /// _MOSTRAR
  ///
  /// Descrição: Método privado que cria e exibe SnackBar com configurações padrão.
  /// Parâmetros:
  /// - context: Contexto para ScaffoldMessenger
  /// - mensagem: Texto a ser exibido
  /// - cor: Cor de fundo da SnackBar
  /// Retorno: void
  ///
  /// Configuração: 3 segundos de duração, comportamento flutuante
  static void _mostrar(BuildContext context, String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),              // Mensagem principal
        backgroundColor: cor,                 // Cor semântica
        duration: const Duration(seconds: 3), // Duração padrão
        behavior: SnackBarBehavior.floating,  // Comportamento flutuante
      ),
    );
  }

  // Fim da classe CustomSnackbar
  // 
  // Utilitário para SnackBars com:
  // 
  // 🎨 CORES SEMÂNTICAS:
  // - Verde: sucesso, confirmações
  // - Vermelho: erros, falhas
  // - Consistência visual em todo app
  // 
  // ⚙️ CONFIGURAÇÃO PADRÃO:
  // - Duração: 3 segundos
  // - Comportamento: flutuante
  // - Texto: mensagem customizável
  // - Posição: inferior da tela
  // 
  // 🔧 USO:
  // - CustomSnackbar.sucesso(context, "Operação realizada!")
  // - CustomSnackbar.erro(context, "Erro ao processar")
  // - Métodos estáticos para facilidade
}
