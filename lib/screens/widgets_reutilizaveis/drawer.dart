import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sudema_app/screens/perfil_page.dart';

class CustomDrawer extends StatefulWidget {
  final String? token;
  final bool forceRandomLogin;
  final VoidCallback? onSortearFinalizado;

  const CustomDrawer({
    super.key,
    this.token,
    this.forceRandomLogin = false,
    this.onSortearFinalizado,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    _sortearLogin();
  }

  @override
  void didUpdateWidget(CustomDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Se a flag vier true, sorteia novamente
    if (widget.forceRandomLogin && !oldWidget.forceRandomLogin) {
      _sortearLogin();
      widget.onSortearFinalizado?.call(); // avisa o HomeScreen para resetar
    }
  }

  void _sortearLogin() {
    final random = Random();
    setState(() {
      isLoggedIn = random.nextBool(); // 50% de chance
    });
  }

  String _getUsername() {
    if (!isLoggedIn || widget.token == null || widget.token!.isEmpty) {
      return 'Acessar';
    } else {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token!);
        return decodedToken['name'] ?? 'Usuário';
      } catch (e) {
        return 'Usuário';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _getUsername();

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
                  leading: const Icon(Icons.feed),
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
                  MaterialPageRoute(builder: (context) => const PerfilPage()),
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
                      const Icon(Icons.person, color: Colors.black54, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          username,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Icon(
                        isLoggedIn ? Icons.settings : Icons.login,
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
