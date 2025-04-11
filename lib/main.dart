import 'package:flutter/material.dart';
import 'package:sudema_app/screens/home_screen.dart';
import 'package:sudema_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,         // Remove a faixa de debug no topo
      title: 'SUDEMA',                           // Nome do app (usado em alguns lugares)
      initialRoute: '/',                         // Primeira tela que será exibida
      routes: {
        '/': (context) => const SplashScreen(),  // Tela splash
        '/home': (context) => const HomeScreen(),// HomeScreen
        // outras rotas virão depois
      },
    );
  }
}
