/// DENUNCIA_WRAPPER_SCREEN
///
/// Responsável por: Envolver o fluxo completo de denúncias com navegação e AppBar consistentes.
/// Utilizado em: Container principal para todo o processo de criação de denúncias.
/// 
/// Esta tela atua como um wrapper que mantém a navegação inferior e AppBar
/// durante todo o fluxo de denúncia, garantindo que o usuário possa navegar
/// para outras seções do app mesmo durante o preenchimento da denúncia.
/// Inicia o fluxo com a tela de seleção de categorias.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/denuncia/categoria/categorias_denuncia.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/home/home_screen.dart';
import 'package:sudema_app/screens/widgets/appbar_denuncia.dart'; 

class DenunciaWrapperScreen extends StatefulWidget {
  const DenunciaWrapperScreen({super.key});

  @override
  State<DenunciaWrapperScreen> createState() => _DenunciaWrapperScreenState();
}

class _DenunciaWrapperScreenState extends State<DenunciaWrapperScreen> {
  // Índice fixo para manter a aba "Denúncias" selecionada na navbar
  final int _selectedIndex = 1;

  /// _onNavBarTap
  ///
  /// Descrição: Gerencia navegação quando usuário toca em outras abas durante denúncia.
  /// Parâmetros:
  /// - index: índice da aba selecionada na navbar
  /// Retorno: void
  ///
  /// Remove todas as telas do fluxo de denúncia e vai para a seção selecionada.
  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return; // Ignora se já está na aba atual

    // Navega para a seção selecionada, removendo o fluxo de denúncia
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(initialIndex: index)),
      (route) => false, // Remove todas as rotas anteriores
    );
  }

  /// Widget DenunciaWrapperScreen
  ///
  /// Descrição: Container principal do fluxo de denúncias com navegação consistente.
  /// Mantém AppBar e NavBar durante todo o processo de criação de denúncia.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DenunciaAppBar(), // AppBar específica para denúncias
      body: const NovaDenuncia(), // Inicia com seleção de categorias
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex, // Mantém aba "Denúncias" selecionada
        onTap: _onNavBarTap,
      ),
    );
  }
}
