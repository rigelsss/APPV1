import 'package:flutter/material.dart';
import 'package:sudema_app/screens/NovaDenuncia.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';

class DenunciaWrapperScreen extends StatefulWidget {
  const DenunciaWrapperScreen({super.key});

  @override
  State<DenunciaWrapperScreen> createState() => _DenunciaWrapperScreenState();
}

class _DenunciaWrapperScreenState extends State<DenunciaWrapperScreen> {
  final int _selectedIndex = 1; // índice da aba "Denúncias"

  void _onNavBarTap(int index) {
    if (index != _selectedIndex) {
      // Se o usuário tocar em outra aba da navbar, volta para a home e troca o índice
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const NovaDenuncia(), // Conteúdo com navegação interna
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
