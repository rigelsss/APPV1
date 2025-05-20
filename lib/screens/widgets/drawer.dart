import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sudema_app/screens/perfil_page.dart';
import 'package:sudema_app/services/AuthMe.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  String username = 'Acessar';
  bool isLoading = true;
  String? _token;

  @override
  void initState() {
    super.initState();
    _carregarTokenEUsuario();
  }

  Future<void> _carregarTokenEUsuario() async {
    final token = await AuthController.getToken();
    setState(() => _token = token);

    if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
      try {
        final data = await AuthController.obterInformacoesUsuario(token);
        if (data != null) {
          setState(() {
            username = data['name'] ?? 'Acessar';
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } catch (e) {
        print('Erro ao carregar nome do usuário: $e');
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  bool get isLoggedIn {
    if (_token == null || _token!.isEmpty) return false;
    try {
      return !JwtDecoder.isExpired(_token!);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 16),
            child: Center(
              child: Image.asset(
                'assets/images/logosimples.png',
                width: 260,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.campaign),
                  title: const Text('Denúncias'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/denuncias');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.beach_access),
                  title: const Text('Balneabilidade'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.newspaper),
                  title: const Text('Notícias'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_in_talk_outlined),
                  title: const Text('Contato'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/contatos');
                  },
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Perfiluser(token: _token)),
                );
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 36),
              child: Column(
                children: [
                  const Divider(height: 1, thickness: 1),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.account_circle_outlined, color: Colors.black54, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isLoading ? 'Carregando...' : username,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Icon(
                        isLoggedIn ? Icons.settings_rounded : Icons.login,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
