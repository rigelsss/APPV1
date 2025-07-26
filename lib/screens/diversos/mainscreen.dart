/// MAINSCREEN
///
/// Responsável por: Controlar a navegação principal do aplicativo SUDEMA através de um BottomNavigationBar.
/// Utilizado em: Tela principal após login/splash, gerencia todas as funcionalidades principais do app.
/// 
/// Este é o container principal que organiza as 4 funcionalidades centrais:
/// - Home (notícias e informações gerais)
/// - Balneabilidade (consulta de praias monitoradas)
/// - Notícias (feed completo de notícias da SUDEMA)
/// - Denúncias (formulário para crimes ambientais)

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/home/home_screen.dart';
import '../widgets/navbar.dart';
import '../denuncia/PageDenuncia.dart';
import '../balneabilidade/balneabilidade.dart';
import '../noticias/pagina_noticias/pagina_noticias.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Índice da aba atualmente selecionada na navegação inferior
  int _currentIndex = 0;

  // Lista das páginas principais do aplicativo SUDEMA
  // Ordem: Home, Balneabilidade, Notícias, Denúncias
  final List<Widget> _pages = [
    const HomeScreen(),        // 0 - Tela inicial com resumo de funcionalidades
    const Balneabilidade(),    // 1 - Consulta de balneabilidade das praias
    const NoticiasPage(),      // 2 - Feed completo de notícias da SUDEMA
    DenunciaPage(),           // 3 - Formulário para denúncias ambientais
  ];

  /// _onTabTapped
  ///
  /// Descrição: Atualiza o índice da navbar e redireciona para a página correspondente.
  /// Parâmetros:
  /// - index: índice da aba selecionada (0-3)
  /// Retorno: void
  ///
  /// Mantém a navegação coerente e atualiza o estado visual da navbar.
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Exibe a página correspondente ao índice selecionado
      body: _pages[_currentIndex],
      // Navbar inferior com as 4 opções principais do app SUDEMA
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
