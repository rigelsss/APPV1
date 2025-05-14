import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sudema_app/screens/PerfilUser.dart';
import 'package:sudema_app/services/AuthMe.dart';

class CustomDrawer extends StatefulWidget {
  final String? token;

  const CustomDrawer({super.key, this.token});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  String username = 'Acessar';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarNomeUsuario();
  }

  Future<void> _carregarNomeUsuario() async {
    if (widget.token != null && widget.token!.isNotEmpty) {
      try {
        final data = await AuthController.obterInformacoesUsuario(widget.token!);
        if (data != null) {
          setState(() {
            username = data['name'] ?? 'Acessar';
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Erro ao carregar nome do usuário: $e');
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool get isLoggedIn {
    if (widget.token == null || widget.token!.isEmpty) {
      return false;
    }
    try {
      return !JwtDecoder.isExpired(widget.token!);
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
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Perfiluser(token: widget.token)),
                );
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
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
                        isLoggedIn ? Icons.logout : Icons.login,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}