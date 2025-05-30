import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/notificacao/notificacoes.dart';
import '../../services/AuthMe.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onLoginTap;
  final bool isLoggedIn;

  const HomeAppBar({
    super.key,
    this.onLoginTap,
    this.isLoggedIn = false,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.isLoggedIn) {
      _fetchUnreadNotifications();
    }
  }

  Future<void> _fetchUnreadNotifications() async {
    try {
      final token = await AuthController.getToken();
      if (token == null) {
        print('Usuário não autenticado');
        return;
      }

      final user = await AuthController.obterInformacoesUsuario(token);
      if (user == null || user['id'] == null) {
        print('Usuário inválido ou sem ID');
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
      } else {
        print('Erro ao buscar notificações: ${response.statusCode}');
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
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        IconButton(
          icon: widget.isLoggedIn
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
          onPressed: widget.isLoggedIn
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificacoesPage(token: ''),
              ),
            ).then((_) {
              _fetchUnreadNotifications();
            });
          }
              : widget.onLoginTap,
        ),
      ],
    );
  }
}
