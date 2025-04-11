import 'package:flutter/material.dart';
import 'dart:async'; // Importa a biblioteca para usar o Timer
import 'home_screen.dart'; // Importa a tela inicial do app


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
    State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Inicia o temporizador para navegar para a tela inicial após 3 segundos
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.jpg', // Caminho da imagem do logo
            fit: BoxFit.cover, // Faz a imagem ocupar toda a tela
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo_gov.webp', // Caminho da imagem do logo
                  width: 160, // Largura da imagem
                  height: 160, // Altura da imagem
                ),
                const SizedBox(width: 20), // Espaço entre as imagens
                Image.asset(
                  'assets/images/logo_sudema.webp', // Caminho da imagem do logo
                  width: 160, // Largura da imagem
                  height: 160, // Altura da imagem
                ),
              ],
            )
          ),
        ], // Faz a imagem ocupar a tela toda
      ),
    );
  }
}