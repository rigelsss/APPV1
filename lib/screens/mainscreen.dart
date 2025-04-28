import 'package:flutter/material.dart';
import 'package:sudema_app/screens/home_screen.dart';
import '../screens/widgets_reutilizaveis/navbar.dart';
import '../screens/PageDenuncia.dart';
import '../screens/praias.dart';
import '../screens/noticias.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    PraiasPage(),
    NoticiasPage(),
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
