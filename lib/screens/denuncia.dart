import 'package:flutter/material.dart';
import '../screens/widgets_reutilizaveis/appbar.dart';

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
              Text(
                'Denúncias',
                style: TextStyle(fontSize: 32),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2A2F8C),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Realizar denúncia',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Por que denunciar?',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 12),
              Text(
                'Denunciar infrações ambientais é um ato de cidadania que contribui para a preservação do meio ambiente e para a redução dos impactos negativos na natureza. As denúncias permitem que os órgãos competentes tomem conhecimento de irregularidades ambientais e que medidas sejam adotadas para minimizar ou reverter os danos causados.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                'O que acontece após a denúncia?',
                style: TextStyle(fontSize: 20, color: Colors.black87),
              ),
              SizedBox(height: 12),
              Text(
                'A denúncia é analisada e, caso as infrações sejam confirmadas, um processo é instaurado. Dependendo da gravidade da infração, o caso pode ser encaminhado para julgamento em âmbito estadual ou federal.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 12),
              Text(
                'O que é considerado infração ambiental?',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 12),
              Text(
                'Foi publicado, em março de 2024, no Diário Oficial do Estado da Paraíba, o Decreto Estadual n° 44.889/2024, que trata das infrações ambientais, do processo administrativo para sua apuração e suas respectivas sanções.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Center(
                child: SizedBox(
                  width: screenWidth * 0.9,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5F5F5),
                    ),
                    child: Text(
                      'Decreto Estadual nº 44.889, de 26 de março de 2024',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
