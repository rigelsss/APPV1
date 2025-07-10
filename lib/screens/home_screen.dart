import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../screens/home_body.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/noticiasTop5_service.dart';
import '../models/noticia.dart';
import 'widgets/appbar.dart';
import 'balneabilidade/balneabilidade.dart';
import 'noticias/pagina_noticias/pagina_noticias.dart';
import 'widgets/navbar.dart';
import 'widgets/drawer.dart';
import 'login.dart';
import 'package:another_flushbar/flushbar.dart';
import '../screens/PageDenuncia.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;
  final Map<String, dynamic>? userInfo;

  const HomeScreen({super.key, this.initialIndex = 0, this.userInfo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? token;
  List<Noticia> _noticias = [];
  int _selectedIndex = 0;
  bool isLoggedIn = false;
  bool _flushbarExibida = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _carregarToken();
    _carregarNoticias();
    _verificarLogoutRecentemente();


    if (!_flushbarExibida && widget.userInfo != null && widget.userInfo!['name'] != null) {
      _flushbarExibida = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Flushbar(
          backgroundColor: const Color(0xFFD2FDE6),
          duration: const Duration(seconds: 4),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(12),
          margin: const EdgeInsets.all(8),
          messageText: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo, ${widget.userInfo!['name']?.split(' ').first}!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B8C00),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Login realizado com sucesso.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B8C00),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ).show(context);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['desativado'] == true && !_flushbarExibida) {
      _flushbarExibida = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Flushbar(
          backgroundColor: const Color(0xFFD2FDE6),
          duration: const Duration(seconds: 4),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(12),
          margin: const EdgeInsets.all(8),
          messageText: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Conta desativada!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B8C00),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Para reativar, basta realizar login novamente.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B8C00),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ).show(context);
      });
    }
  }

  void _onDrawerItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
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
  return WillPopScope(
    onWillPop: () async {
      if (_selectedIndex != 0) {
        setState(() {
          _selectedIndex = 0;
        });
        return false; 
      }
      return false; 
    },
    child: Scaffold(
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
      drawer: CustomDrawer(onItemSelected: _onDrawerItemSelected),
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
    ),
  );
}

  List<Widget> get _pages => [
        HomeBody(
          noticias: _noticias,
          onSelecionarDenuncia: () => setState(() => _selectedIndex = 1),
          onSelecionarNoticias: () => setState(() => _selectedIndex = 3),
          onSelecionarBalneabildiade: () => setState(() => _selectedIndex = 2),
          onSelecionarContatos: () => setState(() => _selectedIndex = 4),
        ),
        const DenunciaPage(),
        const Balneabilidade(),
        const NoticiasPage(),
      ];

  void _verificarLogoutRecentemente() async {
    final prefs = await SharedPreferences.getInstance();
    final logoutRealizado = prefs.getBool('logoutRealizado') ?? false;

    if (logoutRealizado && !_flushbarExibida) {
      _flushbarExibida = true;
      await prefs.setBool('logoutRealizado', false); 

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        backgroundColor: const Color(0xFFD2FDE6),
        duration: const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(12),
        margin: const EdgeInsets.all(8),
        messageText: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Logout realizado com sucesso.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B8C00),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Você foi desconectado com sucesso da sua  conta.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1B8C00),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ).show(context);
    });
  }
}

}
