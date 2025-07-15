import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sudema_app/screens/notificacao/notificacoes.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/editar_perfil.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_menu_item.dart';

class PerfilMenuList extends StatelessWidget {
  final String token;
  final Map<String, dynamic> userData;
  final Function(String novoToken) onSenhaAlterada;
  final bool isTest;

  const PerfilMenuList({
    required this.token,
    required this.userData,
    required this.onSenhaAlterada,
    this.isTest = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PerfilMenuItem(
          icon: SvgPicture.asset(
            'assets/icon/bell.svg',
            width: 24,
            height: 24,
            color: const Color(0xFF747474),
          ),
          title: 'Notificações',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificacoesPage(token: token),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
        const SizedBox(height: 10),
        PerfilMenuItem(
          icon: SvgPicture.asset(
            'assets/icon/user-edit.svg',
            width: 24,
            height: 24,
            color: const Color(0xFF747474),
          ),
          title: 'Editar Perfil',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditarPerfil(
                nomeAtual: userData['name'] ?? '',
                telefoneAtual: userData['phone'] ?? '',
                cpfAtual: userData['cpf'] ?? '',
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
        const SizedBox(height: 10),
        PerfilMenuItem(
          icon: SvgPicture.asset(
            'assets/icon/at-sign.svg',
            width: 24,
            height: 24,
            color: const Color(0xFF747474),
          ),
          title: 'Alterar E-mail',
          onTap: () => Navigator.pushNamed(context, '/EditarEmail'),
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
        const SizedBox(height: 10),
        PerfilMenuItem(
          icon: SvgPicture.asset(
            'assets/icon/lock.svg',
            width: 24,
            height: 24,
            color: const Color(0xFF747474),
          ),
          title: 'Alterar Senha',
          onTap: () async {
            final novoToken = await Navigator.pushNamed(context, '/EditarSenha');
            if (novoToken != null && context.mounted) {
              onSenhaAlterada(novoToken as String);
            }
          },
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey, height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
