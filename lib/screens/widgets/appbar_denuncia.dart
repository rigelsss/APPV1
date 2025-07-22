import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/services/AuthMe.dart';

class DenunciaAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool Function(String)? isTokenExpired;
  const DenunciaAppBar({super.key, this.isTokenExpired});

  @override
  _DenunciaAppBarState createState() => _DenunciaAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DenunciaAppBarState extends State<DenunciaAppBar> {
  bool _logado = false;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _verificarLogin();
  }

  Future<void> _verificarLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      final isExpired = widget.isTokenExpired?.call(token) ?? JwtDecoder.isExpired(token);
      if (!isExpired) {
        setState(() {
          _logado = true;
        });
        await _buscarNotificacoesNaoLidas();
      }
    }
  }

  Future<void> _buscarNotificacoesNaoLidas() async {
    try {
      final token = await AuthController.getToken();
      if (token == null) return;

      final user = await AuthController.obterInformacoesUsuario(token);
      if (user == null || user['id'] == null) return;

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
        final data = jsonDecode(response.body);
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
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      title: Text(
        'Denunciar',
        style: GoogleFonts.lato(fontSize: 24),
      ),
      actions: _logado
          ? [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/notificacoes').then((_) {
                    _buscarNotificacoesNaoLidas();
                  });
                },
                icon: Row(
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
                    SvgPicture.asset(
                      'assets/icon/notificacao.svg',
                      width: 24,
                      height: 24,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
    );
  }
}
