import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class DenunciaAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DenunciaAppBar({super.key});

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
    if (token != null && !JwtDecoder.isExpired(token)) {
      setState(() {
        _logado = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title:  Text(
        'Denúncia',
        style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: _logado
          ? [
              IconButton(
                icon: const Icon(Icons.notifications),
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
