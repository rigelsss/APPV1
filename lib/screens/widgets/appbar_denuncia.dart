import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  @override
  void initState() {
    super.initState();
    _verificarLogin();
  }

  Future<void> _verificarLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      // Usa a função injetada, se existir, senão a padrão do JwtDecoder
      final isExpired = widget.isTokenExpired?.call(token) ?? JwtDecoder.isExpired(token);
      if (!isExpired) {
        setState(() {
          _logado = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
      title:  Text(
        'Denunciar',
        style: GoogleFonts.lato(fontSize: 24),
      ),
      actions: _logado
          ? [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icon/notificacao.svg',
                  width: 24,
                  height: 24,
                  color: Colors.black, 
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/notificacoes');
                },
              ),
            ]
          : 
            [
              IconButton(
                icon: const Icon(Icons.login),
                onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
      ]
    );
  }
}
