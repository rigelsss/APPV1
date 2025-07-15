import 'package:flutter/material.dart';
import 'package:sudema_app/screens/denuncia/categoria/categorias_denuncia.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/home_screen.dart';
import 'package:sudema_app/screens/widgets/appbar_denuncia.dart'; 

class DenunciaWrapperScreen extends StatefulWidget {
  const DenunciaWrapperScreen({super.key});

  @override
  State<DenunciaWrapperScreen> createState() => _DenunciaWrapperScreenState();
}

class _DenunciaWrapperScreenState extends State<DenunciaWrapperScreen> {
  final int _selectedIndex = 1;

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(initialIndex: index)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DenunciaAppBar(), 
      body: const NovaDenuncia(),
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
