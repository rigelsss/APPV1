import 'package:flutter/material.dart';
import 'webview_screen.dart'; 
import 'page_denuncia.dart';

class DenunciaPage extends StatelessWidget {
  const DenunciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Denúncias',
                style: TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NovaDenunciaPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2F8C),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    ),
                    child: const Text(
                      'Fazer uma nova denúncia',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Por que denunciar?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              const Text(
                'Denunciar infrações ambientais é um ato de cidadania que contribui para a preservação do meio ambiente e para a redução dos impactos negativos na natureza. As denúncias permitem que os órgãos competentes tomem conhecimento de irregularidades ambientais e que medidas sejam adotadas para minimizar ou reverter os danos causados.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'O que acontece após a denúncia?',
                style: TextStyle(fontSize: 20, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              const Text(
                'A denúncia é analisada e, caso as infrações sejam confirmadas, um processo é instaurado. Dependendo da gravidade da infração, o caso pode ser encaminhado para julgamento em âmbito estadual ou federal.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              const Text(
                'O que é considerado infração ambiental?',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              const Text(
                'Foi publicado, em março de 2024, no Diário Oficial do Estado da Paraíba, o Decreto Estadual n° 44.889/2024, que trata das infrações ambientais, do processo administrativo para sua apuração e suas respectivas sanções.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),

              Center(
                child: InkWell(
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
                    width: screenWidth * 0.9,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      'Decreto Estadual nº 44.889, de 26 de março de 2024',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
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
