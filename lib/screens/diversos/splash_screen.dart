/// SPLASH_SCREEN
///
/// Responsável por: Exibir a tela inicial do aplicativo SUDEMA com animação de transição.
/// Utilizado em: Primeira tela exibida ao abrir o aplicativo, antes de ir para a home.
/// 
/// Esta tela mostra os logos do Governo da Paraíba e da SUDEMA sobre um fundo
/// personalizado, com uma animação de fade que dura 3 segundos antes de
/// redirecionar automaticamente para a tela principal.

import 'package:flutter/material.dart';
import 'dart:async';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Controlador para a animação de fade da splash screen
  late AnimationController _controller;
  // Animação que controla a opacidade (fade out)
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configura o controlador de animação com duração de 3 segundos
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Cria animação de fade (opacidade de 1.0 para 0.0)
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Aguarda 2 segundos, depois inicia o fade e navega para a home
    Timer(const Duration(seconds: 2), () {
      _controller.forward().whenComplete(() {
        // Substitui a splash pela tela principal
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      });
    });
  }

  @override
  void dispose() {
    // Libera recursos do controlador de animação
    _controller.dispose();
    super.dispose();
  }

  /// Widget SplashScreen
  ///
  /// Descrição: Interface da tela de splash com logos institucionais e animação.
  /// Exibe fundo personalizado com logos do Governo da PB e SUDEMA centralizados.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animation, // Aplica a animação de fade
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Imagem de fundo da splash screen
            Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover, // Cobre toda a tela
            ),
            // Logos centralizados
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo do Governo da Paraíba
                  Image.asset(
                    'assets/images/logo_gov.webp',
                    width: 160,
                    height: 160,
                  ),
                  const SizedBox(width: 20), // Espaçamento entre logos
                  // Logo da SUDEMA
                  Image.asset(
                    'assets/images/logo_sudema.webp',
                    width: 160,
                    height: 160,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
