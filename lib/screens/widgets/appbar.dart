/// APPBAR
///
/// Responsável por: AppBar da tela home com logo SUDEMA, menu lateral,
/// botão de login/notificações e contador de mensagens não lidas.
/// Utilizado em: Tela principal (home) como cabeçalho padrão.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/notificacao/notificacoes.dart';
import '../../services/AuthMe.dart';

/// Widget HomeAppBar
///
/// Descrição: AppBar adaptativa que muda comportamento baseado no estado de login,
/// exibindo logo centralizado, menu lateral e ações contextuais.
class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback? onLoginTap;  // Callback opcional para login customizado

  const HomeAppBar({
    super.key,
    this.onLoginTap, 
    required bool isLoggedIn,  // Parâmetro obrigatório (não usado internamente)
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  int _unreadCount = 0;     // Contador de notificações não lidas
  bool _isLoggedIn = false; // Estado de login do usuário

  /// INITSTATE
  ///
  /// Descrição: Inicializa widget verificando status de login.
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();  // Verifica se usuário está logado
  }

  /// _CHECKLOGINSTATUS
  ///
  /// Descrição: Verifica se usuário está logado e busca notificações se necessário.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  Future<void> _checkLoginStatus() async {
    final token = await AuthController.getToken();
    setState(() {
      _isLoggedIn = token != null;  // Define estado baseado na existência do token
    });

    // Se logado, busca contador de notificações
    if (_isLoggedIn) {
      _fetchUnreadNotifications();
    }
  }

  /// _FETCHUNREADNOTIFICATIONS
  ///
  /// Descrição: Busca contador de notificações não lidas via API.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Endpoint: GET /usuarios/mobile/{id}/notificacoes
  Future<void> _fetchUnreadNotifications() async {
    try {
      // Obtém token para autenticação
      final token = await AuthController.getToken();
      if (token == null) {
        return;  // Sai se não há token
      }

      // Obtém dados do usuário para extrair ID
      final user = await AuthController.obterInformacoesUsuario(token);
      if (user == null || user['id'] == null) {
        return;  // Sai se não conseguiu obter dados
      }

      // Constrói URL do endpoint de notificações
      final userId = user['id'].toString();
      final url = Uri.parse('${dotenv.env['URL_API']}/usuarios/mobile/$userId/notificacoes');

      /// Integração com API SUDEMA
      ///
      /// Endpoint: GET /usuarios/mobile/{id}/notificacoes
      /// Resposta: { "total_notificacoes_nao_lidas": number }
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',  // Autenticação JWT
          'Content-Type': 'application/json',
        },
      );

      // Processa resposta se bem-sucedida
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          // Atualiza contador (padrão 0 se campo não existe)
          _unreadCount = data['total_notificacoes_nao_lidas'] ?? 0;
        });
      }
    } catch (e) {
      // Log de erro sem interromper funcionamento
      print('Erro ao buscar notificações: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white, 
      centerTitle: true,
      title: Center(
        child: Image.asset(
        'assets/images/logosimples.png',
        height: kToolbarHeight - 8, 
        fit: BoxFit.contain,
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        IconButton(
          key: const Key('login_button'),
          icon: _isLoggedIn
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_unreadCount > 0) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    _unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              const Icon(Icons.notifications_none, color: Color(0xFF3B3B3B),),
            ],
          )
              : const Icon(Icons.login),
          onPressed: () {
            if (_isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificacoesPage(token: ''),
                ),
              ).then((_) {
                _fetchUnreadNotifications();
              });
            } else {
              if (widget.onLoginTap != null) {
                widget.onLoginTap!();
              } else {
                Navigator.pushNamed(context, '/login');
              }
            }
          },
        ),
      ],
    );
  }
}
