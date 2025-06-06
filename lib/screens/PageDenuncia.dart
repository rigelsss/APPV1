import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'webview_screen.dart';
import 'denunciawraprellerscreen.dart';

class DenunciaPage extends StatelessWidget {
  const DenunciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tituloStyle = GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );
    final textoStyle = GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w300, 
    );
    final botaoStyle = GoogleFonts.lato(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
    final linkStyle = GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: const Color(0xFF2A2F8C),
      decoration: TextDecoration.underline,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Denúncias',
                style: tituloStyle.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DenunciaWrapperScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2F8C),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Realizar denúncia',
                    style: botaoStyle,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Por que denunciar?', style: tituloStyle),
              const SizedBox(height: 12),
              Text(
                'Denunciar infrações ambientais é um ato de cidadania que contribui para a preservação do meio ambiente e para a redução dos impactos negativos na natureza. As denúncias permitem que os órgãos competentes tomem conhecimento de irregularidades ambientais e que medidas sejam adotadas para minimizar ou reverter os danos causados.',
                style: textoStyle,
              ),
              const SizedBox(height: 12),
              Text('O que acontece após a denúncia?', style: tituloStyle),
              const SizedBox(height: 12),
              Text(
                'A denúncia é analisada e, caso as infrações sejam confirmadas, um processo é instaurado. Dependendo da gravidade da infração, o caso pode ser encaminhado para julgamento em âmbito estadual ou federal.',
                style: textoStyle,
              ),
              const SizedBox(height: 12),
              Text('O que é considerado infração ambiental?', style: tituloStyle),
              const SizedBox(height: 12),
              Text(
                'Foi publicado, em março de 2024, no Diário Oficial do Estado da Paraíba, o Decreto Estadual n° 44.889/2024, que trata das infrações ambientais, do processo administrativo para sua apuração e suas respectivas sanções.',
                style: textoStyle,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WebViewScreen(
                        url: 'https://drive.google.com/file/d/1Bb3IhBcoZLN2FkPm_vzzkhkvhBMT7BQ_/view',
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2A2F8C)),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Decreto Estadual nº 44.889, de 26 de março de 2024',
                      style: linkStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
