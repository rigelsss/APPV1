import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/perfil/perfil/controller/perfil_controller.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_appbar.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_user_infocard.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_menu_list.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_footer_botoes.dart';

class Perfiluser extends StatefulWidget {
  final String? token;
  //final PerfilController? controller;

  const Perfiluser({super.key, this.token,});

  @override
  PerfiluserState createState() => PerfiluserState();
}

class PerfiluserState extends State<Perfiluser> {
  final controller = PerfilController();
  //late final PerfilController controller; 'teste de funcao'
  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();
    //controller = widget.controller ?? PerfilController(); 'teste de funcao'
    controller.addListener(_updateState);
    controller.prepararToken(tokenExterno: widget.token);
  }

  @override
  void dispose() {
    controller.removeListener(_updateState);
    controller.dispose();
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleSenhaAlterada(String novoToken) {
    controller.token = novoToken;
    controller.isLoading = true;
    controller.errorFetching = false;
    controller.carregarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.errorFetching && controller.errorMessage.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        _showErrorDialog(context, controller.errorMessage);
      });
    }

    return Scaffold(
      appBar: PerfilHeader(nome: controller.userData['name']),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorFetching) {
            return Center(child: Text('Erro ao carregar perfil: ${controller.errorMessage}'));
          } else if (controller.userData.isEmpty) {
            return const Center(child: Text('Nenhuma informação de usuário encontrada'));
          } else {
            return _buildPerfil(context);
          }
        },
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        enabled: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/denuncias');
              break;
            case 2:
              Navigator.pushNamed(context, 'balneabilidade');
              break;
            case 3:
              Navigator.pushNamed(context, '/noticias');
              break;
          }
        },
      ),
    );
  }

  Widget _buildPerfil(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          PerfilInfoCard(userData: controller.userData),
          const SizedBox(height: 20),
          Expanded(
            child: PerfilMenuList(
              token: controller.token,
              userData: controller.userData,
              onSenhaAlterada: _handleSenhaAlterada,
            ),
          ),
          PerfilFooterButtons(onLogout: () => controller.logout(context)),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text("Erro ao buscar dados do usuário: $message"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
