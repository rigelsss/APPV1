import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticiasMaisAntigas extends StatelessWidget {
  const NoticiasMaisAntigas({super.key});

  void _abrirMaisNoticias() async {
    const url = 'https://sudema.pb.gov.br/noticias';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
    } else {
      debugPrint('❌ Não foi possível abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Deseja visualizar notícias mais antigas?',
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _abrirMaisNoticias,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A2F8C),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Acesse aqui',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
