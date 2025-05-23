import 'package:flutter/material.dart';
class BannerDenuncia extends StatelessWidget {
  final VoidCallback onTap;

  const BannerDenuncia({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // ⬅️ Detecta largura da tela
    final screenHeight = MediaQuery.of(context).size.height; // ⬅️ Detecta altura da tela

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth * 0.9, // ✅ Responsivo com base no tamanho da tela
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/denuncia_bg.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: screenWidth * 0.25, // ✅ Altura proporcional
                ),
              ),
              Container(
                height: screenWidth * 0.25,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04, // ✅ Padding proporcional
                  vertical: screenHeight * 0.015,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Identificou uma infração ambiental?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.040, // ✅ Tamanho do texto proporcional
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01), // ✅ Espaço proporcional
                          Text(
                            'Faça uma denúncia!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.040,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/megafone.png',
                      width: screenWidth * 0.12, // ✅ Tamanho proporcional
                      height: screenWidth * 0.12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
