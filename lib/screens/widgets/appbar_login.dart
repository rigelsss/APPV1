/// APPBAR_LOGIN
///
/// Responsável por: AppBar simples e reutilizável com título customizável
/// e botão de voltar padrão.
/// Utilizado em: Telas de login, recuperação de senha e formulários.

import 'package:flutter/material.dart';

/// Widget AppBarDenuncia
///
/// Descrição: AppBar genérica com título dinâmico e navegação de volta.
/// Nome: Confuso - deveria ser AppBarLogin ou AppBarGeneric.
class AppBarDenuncia extends StatelessWidget implements PreferredSizeWidget {
  final String title;  // Título a ser exibido na AppBar

  const AppBarDenuncia({super.key, required this.title});

  /// BUILD
  ///
  /// Descrição: Constrói AppBar simples com fundo branco e botão de volta.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget AppBar configurada
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,      // Fundo branco
      surfaceTintColor: Colors.white,     // Remove tint do Material 3
      titleSpacing: 0,                    // Remove espaçamento extra do título
      title: Text(title),                 // Título dinâmico
      // Botão de volta padrão
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);  // Volta para tela anterior
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // Fim da classe AppBarDenuncia
  // 
  // AppBar genérica com:
  // - Título customizável
  // - Fundo branco consistente
  // - Botão de volta padrão
  // - Sem espaçamento extra
  // - Altura padrão do toolbar
  // 
  // NOTA: Nome confuso - não é específica para denúncias
}
