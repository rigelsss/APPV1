import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../screens/home_body.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/noticiasTop5_service.dart';
import '../models/noticia.dart';
import 'widgets/appbar.dart';
import '../screens/praias.dart';
import '../screens/PageDenuncia.dart';
import '../screens/noticias.dart';
import 'widgets/navbar.dart';
import 'widgets/drawer.dart';
import 'login.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? token;
  List<Noticia> _noticias = [];
  int _selectedIndex = 0;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _carregarToken();
    _carregarNoticias();
  }

  Future<void> _carregarToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken != null && savedToken.isNotEmpty && !JwtDecoder.isExpired(savedToken)) {
      setState(() {
        token = savedToken;
        isLoggedIn = true;
      });
    } else {
      setState(() {
        token = null;
        isLoggedIn = false;
      });
    }
  }

  void _carregarNoticias() async {
    try {
      final listaNoticias = await CarregarNoticias().buscarNoticias();
      setState(() {
        _noticias = listaNoticias;
      });
    } catch (e) {
      print('Erro ao carregar notícias: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        isLoggedIn: isLoggedIn,
        onLoginTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );

          if (result != null && result is String) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', result);
            setState(() {
              token = result;
              isLoggedIn = !JwtDecoder.isExpired(result);
            });
          }
        },
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

List<Widget> get _pages => [
  HomeBody(
    noticias: _noticias,
    onSelecionarDenuncia: () => setState(() => _selectedIndex = 1),
    onSelecionarNoticias: () => setState(() => _selectedIndex = 2),
  ),
  const DenunciaPage(),
  const PraiasPage(),
  const NoticiasPage(),
  ];
}
