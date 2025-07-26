/// PERFIL_MENU_LIST
///
/// Responsável por: Lista de opções do menu de perfil com navegação para diferentes
/// funcionalidades (notificações, editar perfil, alterar e-mail/senha).
/// Utilizado em: Tela de perfil como menu principal de opções do usuário.

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sudema_app/screens/notificacao/notificacoes.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/editar_perfil.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_menu_item.dart';

/// Widget PerfilMenuList
///
/// Descrição: ListView com itens de menu separados por dividers, cada um com
/// ícone SVG, título e navegação específica.
class PerfilMenuList extends StatelessWidget {
  final String token;                           // Token JWT para autenticação
  final Map<String, dynamic> userData;         // Dados do usuário
  final Function(String novoToken) onSenhaAlterada;  // Callback para senha alterada
  final bool isTest;                            // Flag para testes (padrão: false)

  const PerfilMenuList({
    required this.token,
    required this.userData,
    required this.onSenhaAlterada,
    this.isTest = false,
    super.key,
  });

  /// BUILD
  ///
  /// Descrição: Constrói lista de opções do menu com ícones, títulos e navegação.
  /// Parâmetros:
  /// - context: Contexto do widget para navegação
  /// Retorno: Widget ListView com itens do menu
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Opção 1: Notificações
        PerfilMenuItem(
          icon: SvgPicture.asset(
            'assets/icon/bell.svg',
            width: 24,
            height: 24,
            color: const Color(0xFF747474),  // Cinza padrão dos ícones
          ),
          title: 'Notificações',
          // Navega para tela de notificações com token
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificacoesPage(token: token),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Divider entre opções
        const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
        const SizedBox(height: 10),
        // Opção 2: Editar Perfil
        PerfilMenuItem(
          icon: SvgPicture.asset(
            'assets/icon/user-edit.svg',
            width: 24,
            height: 24,
            color: const Color(0xFF747474),
          ),
          title: 'Editar Perfil',
          // Navega para tela de edição com dados atuais
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditarPerfil(
                nomeAtual: userData['name'] ?? '',      // Nome atual ou vazio
                telefoneAtual: userData['phone'] ?? '',  // Telefone atual ou vazio
                cpfAtual: userData['cpf'] ?? '',         // CPF atual ou vazio
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
        const SizedBox(height: 10),
        // Opção 3: Alterar E-mail
        PerfilMenuItem(
          icon: SvgPicture.asset(
            'assets/icon/at-sign.svg',
            width: 24,
            height: 24,
            color: const Color(0xFF747474),
          ),
          title: 'Alterar E-mail',
          // Navega via rota nomeada
          onTap: () => Navigator.pushNamed(context, '/EditarEmail'),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
        const SizedBox(height: 10),
        // Opção 4: Alterar Senha
        PerfilMenuItem(
          icon: SvgPicture.asset(
            'assets/icon/lock.svg',
            width: 24,
            height: 24,
            color: const Color(0xFF747474),
          ),
          title: 'Alterar Senha',
          // Navega e aguarda retorno de novo token
          onTap: () async {
            final novoToken = await Navigator.pushNamed(context, '/EditarSenha');
            // Se retornou novo token e contexto ainda válido
            if (novoToken != null && context.mounted) {
              onSenhaAlterada(novoToken as String);  // Executa callback
            }
          },
        ),
        const SizedBox(height: 10),
        // Último divider
        const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
      ],
    );
  }

  // Fim da classe PerfilMenuList
  // 
  // Menu de opções do perfil com:
  // - 4 opções principais (notificações, editar perfil, alterar e-mail/senha)
  // - Ícones SVG consistentes
  // - Dividers entre opções
  // - Navegação diferenciada (push, pushNamed)
  // - Callback para atualização de token após alteração de senha
}
