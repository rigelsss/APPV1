import 'package:flutter/material.dart';
import '../screens/widgets_reutilizaveis/drawer.dart';
import '../screens/widgets_reutilizaveis/appbar.dart';
import '../models/noticia.dart';

class HomePage extends StatefulWidget {
  final List<Noticia> noticias;
  const HomePage({super.key, required this.noticias});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool userIsLoggedIn = false;

  void _simulateLogin() {
    setState(() {
      userIsLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isLoggedIn: userIsLoggedIn,
        onLoginTap: () {
          Navigator.pushNamed(context, '/login').then((_) {
            _simulateLogin();
          });
        },
        onNotificationTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Você tem novas notificações')),
          );
        },
      ),
      drawer: const CustomDrawer(),
      body: const Center(child: Text('Página Inicial')),
    );
  }
}
