import 'package:flutter/material.dart';
import 'package:sudema_app/screens/PageDenuncia.dart';
import 'package:sudema_app/screens/home_screen.dart';
import 'package:sudema_app/screens/login.dart';
import 'package:sudema_app/screens/splash_screen.dart';
import 'package:sudema_app/screens/editarperfil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SUDEMA',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginPage(),
        '/denuncias': (context) => const DenunciaPage(),
        '/editar-perfil': (context) => const editarperfil(),
      },
    );
  }
}
