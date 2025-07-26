/// CADASTRO_SCREEN
///
/// Responsável por: Tela principal de cadastro de novos usuários no app SUDEMA.
/// Utilizado em: Fluxo de autenticação para permitir que cidadãos se registrem
/// e possam fazer denúncias ambientais autenticadas.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets/appbar_login.dart';
import 'package:sudema_app/screens/cadastro/widgets/cadastro_form.dart';

/// Widget RegistroUser
///
/// Descrição: Tela de cadastro com layout responsivo que centraliza o formulário
/// e limita sua largura máxima para melhor experiência em tablets/desktop.
class RegistroUser extends StatelessWidget {
  const RegistroUser({super.key});

  /// BUILD
  ///
  /// Descrição: Constrói tela de cadastro com layout responsivo e formulário centralizado.
  /// Parâmetros:
  /// - context: Contexto do widget para navegação e tema
  /// Retorno: Widget Scaffold com estrutura completa da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar personalizada para telas de autenticação
      appBar: AppBarDenuncia(title: 'Cadastro'),
      backgroundColor: Colors.white,
      // LayoutBuilder para responsividade
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Align(
              alignment: Alignment.topCenter, // Centraliza horizontalmente
              child: ConstrainedBox(
                // Limita largura máxima para melhor legibilidade em telas grandes
                constraints: const BoxConstraints(maxWidth: 600),
                // Formulário principal de cadastro
                child: const CadastroForm(),
              ),
            ),
          );
        },
      ),
    );
  }
}
