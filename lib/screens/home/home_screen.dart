/// HOME_SCREEN
///
/// Responsável por: Tela principal do app SUDEMA que gerencia navegação entre seções,
/// autenticação de usuário, carregamento de notícias e feedback visual de ações.
/// Utilizado em: Ponto central do app, acessível após splash screen e login.

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'home_body.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/noticiasTop5_service.dart';
import '../../models/noticia.dart';
import '../widgets/appbar.dart';
import '../balneabilidade/balneabilidade.dart';
import '../noticias/pagina_noticias/pagina_noticias.dart';
import '../widgets/navbar.dart';
import '../widgets/drawer.dart';
import '/screens/login/login.dart';
import 'package:another_flushbar/flushbar.dart';
import '../denuncia/PageDenuncia.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Widget HomeScreen
///
/// Descrição: Tela principal com navegação por abas, gerenciamento de autenticação
/// e feedback visual para ações do usuário (login, logout, reativação de conta).
class HomeScreen extends StatefulWidget {
  final int initialIndex;                    // Índice inicial da aba selecionada
  final Map<String, dynamic>? userInfo;      // Informações do usuário logado (opcional)

  const HomeScreen({super.key, this.initialIndex = 0, this.userInfo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Autenticação e token JWT
  String? token;                    // Token JWT armazenado localmente
  bool isLoggedIn = false;          // Estado de autenticação do usuário
  
  // Dados e navegação
  List<Noticia> _noticias = [];     // Lista de notícias carregadas da API
  int _selectedIndex = 0;           // Índice da aba atualmente selecionada
  
  // Controle de feedback visual
  bool _flushbarExibida = false;    // Previne exibição múltipla de Flushbars

  /// INITSTATE
  ///
  /// Descrição: Inicializa estado da tela, carrega dados e configura feedback de login.
  /// Executa: configuração inicial → carregamento de dados → verificações → feedback visual
  @override
  void initState() {
    super.initState();
    // Configura índice inicial da navegação
    _selectedIndex = widget.initialIndex;
    
    // Carrega dados essenciais
    _carregarToken();                    // Verifica autenticação salva
    _carregarNoticias();                 // Busca notícias da API
    _verificarLogoutRecentemente();      // Verifica se houve logout recente

    // Exibe feedback de boas-vindas após login bem-sucedido
    if (!_flushbarExibida && widget.userInfo != null && widget.userInfo!['name'] != null) {
      _flushbarExibida = true; // Marca como exibida para evitar duplicação

      // Agenda exibição após construção da tela
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Flushbar de boas-vindas após login bem-sucedido
        Flushbar(
          backgroundColor: const Color(0xFFD2FDE6),    // Fundo verde claro
          duration: const Duration(seconds: 4),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(12),
          margin: const EdgeInsets.all(8),
          messageText: Row(
            children: [
              // Ícone de sucesso verde
              const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mensagem personalizada com primeiro nome do usuário
                    Text(
                      'Bem-vindo, ${widget.userInfo!['name']?.split(' ').first}!',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B8C00),           // Verde escuro
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Confirmação de login
                    const Text(
                      'Login realizado com sucesso.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1B8C00),           // Verde escuro
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

  /// _ONDRAWERITEMSELECTED
  ///
  /// Descrição: Callback executado quando item do drawer é selecionado.
  /// Parâmetros:
  /// - index: Índice da aba selecionada no drawer
  /// Retorno: void
  void _onDrawerItemSelected(int index) {
    setState(() {
      _selectedIndex = index;  // Atualiza aba ativa
    });
    Navigator.of(context).pop();  // Fecha drawer
  }

  /// _CARREGARTOKEN
  ///
  /// Descrição: Carrega e valida token JWT salvo localmente para manter login.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Verifica se token existe, não está vazio e não expirou.
  Future<void> _carregarToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    // Valida token: existe, não vazio e não expirado
    if (savedToken != null && savedToken.isNotEmpty && !JwtDecoder.isExpired(savedToken)) {
      setState(() {
        token = savedToken;
        isLoggedIn = true;  // Usuário autenticado
      });
    } else {
      setState(() {
        token = null;
        isLoggedIn = false;  // Usuário não autenticado
      });
    }
  }

  /// _CARREGARNOTICIAS
  ///
  /// Descrição: Carrega lista de notícias da API para exibir na home.
  /// Parâmetros: nenhum
  /// Retorno: void (assíncrono)
  ///
  /// Busca top 5 notícias via service e atualiza estado.
  void _carregarNoticias() async {
    try {
      final listaNoticias = await CarregarNoticias().buscarNoticias();
      setState(() {
        _noticias = listaNoticias;  // Atualiza lista de notícias
      });
    } catch (e) {
      print('Erro ao carregar notícias: $e');  // Log do erro
    }
  }

/// BUILD
///
/// Descrição: Constrói estrutura principal da tela com navegação, AppBar, drawer e conteúdo.
/// Parâmetros:
/// - context: Contexto do widget
/// Retorno: Widget AnnotatedRegion com Scaffold completo
@override
Widget build(BuildContext context) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    // Configura status bar com fundo branco e ícones escuros
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.white, 
      statusBarIconBrightness: Brightness.dark, 
    ),
    child: WillPopScope(
      // Intercepta botão voltar do Android
      onWillPop: () async {
        if (_selectedIndex != 0) {
          // Se não está na home, volta para home
          setState(() {
            _selectedIndex = 0;
          });
          return false;  // Não sai do app
        }
        return false;  // Bloqueia saída do app
      },
      child: Scaffold(
        // AppBar personalizada com estado de login
        appBar: HomeAppBar(
          isLoggedIn: isLoggedIn,
          // Callback para navegar para tela de login
          onLoginTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );

            // Processa resultado do login
            if (result != null && result is String) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', result);  // Salva token
              setState(() {
                token = result;
                isLoggedIn = !JwtDecoder.isExpired(result);  // Valida token
              });
            }
          },
        ),
        // Drawer lateral com navegação
        drawer: CustomDrawer(onItemSelected: _onDrawerItemSelected),
        backgroundColor: Colors.white,
        // Conteúdo principal baseado na aba selecionada
        body: _pages[_selectedIndex],
        // Barra de navegação inferior
        bottomNavigationBar: NavBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;  // Muda aba ativa
            });
          },
        ),
      ),
    ),
  );
}

  /// _PAGES
  ///
  /// Descrição: Getter que retorna lista de páginas correspondentes às abas da navegação.
  /// Índices: 0=Home, 1=Denúncias, 2=Balneabilidade, 3=Notícias
  /// Retorno: List<Widget> - páginas da navegação
  List<Widget> get _pages => [
        // Índice 0: Home com notícias e callbacks de navegação
        HomeBody(
          noticias: _noticias,
          onSelecionarDenuncia: () => setState(() => _selectedIndex = 1),      // Vai para aba 1
          onSelecionarNoticias: () => setState(() => _selectedIndex = 3),       // Vai para aba 3
          onSelecionarBalneabildiade: () => setState(() => _selectedIndex = 2), // Vai para aba 2
          onSelecionarContatos: () => setState(() => _selectedIndex = 4),       // Vai para aba 4
        ),
        // Índice 1: Página de denúncias
        const DenunciaPage(),
        // Índice 2: Página de balneabilidade
        const Balneabilidade(),
        // Índice 3: Página de notícias
        const NoticiasPage(),
      ];

  /// _VERIFICARLOGOUTRECENTEMENTE
  ///
  /// Descrição: Verifica se houve logout recente e exibe feedback visual.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Usado para mostrar mensagem de confirmação após logout bem-sucedido.
  void _verificarLogoutRecentemente() async {
    final prefs = await SharedPreferences.getInstance();
    final logoutRealizado = prefs.getBool('logoutRealizado') ?? false;

    // Exibe feedback apenas se logout foi realizado e Flushbar não foi exibida
    if (logoutRealizado && !_flushbarExibida) {
      _flushbarExibida = true;  // Marca como exibida
      await prefs.setBool('logoutRealizado', false);  // Limpa flag 

    // Agenda exibição após construção da tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Flushbar de confirmação de logout
      Flushbar(
        backgroundColor: const Color(0xFFD2FDE6),    // Fundo verde claro
        duration: const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(12),
        margin: const EdgeInsets.all(8),
        messageText: Row(
          children: [
            // Ícone de sucesso verde
            const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Título da mensagem
                  Text(
                    'Logout realizado com sucesso.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B8C00),           // Verde escuro
                    ),
                  ),
                  SizedBox(height: 4),
                  // Descrição da ação
                  Text(
                    'Você foi desconectado com sucesso da sua conta.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1B8C00),           // Verde escuro
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

  // Fim da classe _HomeScreenState
  // 
  // Tela principal do app SUDEMA com:
  // - Navegação por abas (Home, Denúncias, Balneabilidade, Notícias)
  // - Gerenciamento de autenticação com JWT
  // - Feedback visual para login/logout
  // - Carregamento de notícias da API
  // - Drawer lateral e bottom navigation
  // - Controle de saída do app
}

}
