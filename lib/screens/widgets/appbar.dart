import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/notificacao/notificacoes.dart';
import '../../services/AuthMe.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onLoginTap;

  const HomeAppBar({
    super.key,
    this.onLoginTap, required bool isLoggedIn,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  int _unreadCount = 0;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final token = await AuthController.getToken();
    setState(() {
      _isLoggedIn = token != null;
    });

    if (_isLoggedIn) {
      _fetchUnreadNotifications();
    }
  }

  Future<void> _fetchUnreadNotifications() async {
    try {
      final token = await AuthController.getToken();
      if (token == null) {
        return;
      }

      final user = await AuthController.obterInformacoesUsuario(token);
      if (user == null || user['id'] == null) {
        return;
      }

      final userId = user['id'].toString();
      final url = Uri.parse('${dotenv.env['URL_API']}/usuarios/mobile/$userId/notificacoes');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _unreadCount = data['total_notificacoes_nao_lidas'] ?? 0;
        });
      }
    } catch (e) {
      print('Erro ao buscar notificações: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: SizedBox(
        height: 40,
        child: Image.asset('assets/images/logosimples.png'),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        IconButton(
          icon: _isLoggedIn
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_unreadCount > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    _unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              const Icon(Icons.notifications),
            ],
          )
              : const Icon(Icons.login),
          onPressed: () {
            if (_isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificacoesPage(token: ''),
                ),
              ).then((_) {
                _fetchUnreadNotifications();
              });
            } else {
              if (widget.onLoginTap != null) {
                widget.onLoginTap!();
              } else {
                // Caso não tenha callback, abre rota padrão de login:
                Navigator.pushNamed(context, '/login');
              }
            }
          },
        ),
      ],
    );
  }
}
