/// ALTERAR_SENHA
///
/// Responsável por: Tela para alteração de senha do usuário com formulário
/// de validação e navegação integrada.
/// Utilizado em: Menu de perfil para permitir alteração segura de senha.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/perfil/menu/alterarsenha/form/alterar_senha_form.dart';

/// Widget EditarSenha
///
/// Descrição: Tela com formulário de alteração de senha, scroll responsivo
/// e navegação inferior integrada.
class EditarSenha extends StatefulWidget {
  const EditarSenha({super.key});

  @override
  State<EditarSenha> createState() => _EditarSenhaState();
}

class _EditarSenhaState extends State<EditarSenha> {
  int _currentIndex = -1;  // Índice da navegação inferior (-1 = nenhuma selecionada)

  /// _ONNAVBARTAP
  ///
  /// Descrição: Gerencia navegação da barra inferior com atualização de estado.
  /// Parâmetros:
  /// - index: Índice da aba selecionada
  /// Retorno: void
  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;  // Atualiza índice selecionado
    });

    // Navegação baseada no índice
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');       // Home
        break;
      case 1:
        Navigator.pushNamed(context, '/denuncias');  // Denúncias
        break;
      case 2:
        Navigator.pushNamed(context, '/praias');     // Praias/Balneabilidade
        break;
      case 3:
        Navigator.pushNamed(context, '/noticias');   // Notícias
        break;
    }
  }

  /// BUILD
  ///
  /// Descrição: Constrói tela com formulário scrollável e navegação.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Scaffold com estrutura completa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,  // Redimensiona quando teclado aparece
      backgroundColor: Colors.white,
      // AppBar com título e botão de voltar
      appBar: AppBar(
        title: const Text('Alterar senha'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,  // Remove tint do Material 3
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);  // Volta para tela anterior
          },
        ),
      ),
      // Body com scroll responsivo
      body: SafeArea(
        child: GestureDetector(
          // Remove foco dos campos ao tocar fora
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                physics: const AlwaysScrollableScrollPhysics(),  // Sempre scrollável
                child: ConstrainedBox(
                  // Garante altura mínima igual à tela
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: const IntrinsicHeight(
                    // Formulário principal de alteração de senha
                    child: AlterarSenhaForm(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      // Navegação inferior
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  // Fim da classe EditarSenha
  // 
  // Tela de alteração de senha com:
  // - Formulário scrollável responsivo
  // - Dismiss de teclado ao tocar fora
  // - AppBar com navegação de volta
  // - Navegação inferior integrada
  // - Layout que se adapta ao teclado
}
