import 'package:flutter/material.dart';
import 'package:sudema_app/screens/home_screen.dart';
import 'widgets/navbar.dart';
import '../screens/PageDenuncia.dart';
import 'balneabilidade/balneabilidade.dart';
import 'noticias/pagina_noticias/pagina_noticias.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Balneabilidade(),
    const NoticiasPage(),
    DenunciaPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
