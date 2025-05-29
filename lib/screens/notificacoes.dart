import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Firebase Messaging
import '../services/AuthMe.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key, required String token});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  bool _ativado = false;
  List<dynamic> _notificacoes = [];
  int _currentIndex = -1;

  @override
  void initState() {
    super.initState();
    _solicitarPermissaoNotificacoes();
    _carregarEstado();
    _carregarNotificacoes();
  }

  Future<void> _solicitarPermissaoNotificacoes() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permissão concedida para notificações');
    } else {
      print('Permissão negada para notificações');
    }
  }

  Future<void> _carregarEstado() async {
    setState(() {
      _ativado = true;
    });
  }

  Future<bool> _ativarNotificacoesPush(bool ativar) async {
    final token = await AuthController.getToken();
    if (token == null) {
      print('🔒 Usuário não autenticado.');
      return false;
    }

    final user = await AuthController.obterInformacoesUsuario(token);
    if (user == null || user['id'] == null) {
      print('❌ Usuário inválido ou sem ID.');
      return false;
    }

    final userId = user['id'].toString();

    if (ativar) {
      final deviceToken = await FirebaseMessaging.instance.getToken();
      if (deviceToken == null) {
        print('❌ Não foi possível obter deviceToken do Firebase');
        return false;
      }

      final url = Uri.parse('${dotenv.env['URL_API']}/usuarios/mobile/$userId/notificacoes/ativar');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'deviceToken': deviceToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Notificações ativadas com sucesso');
        return true;
      } else {
        print('❌ Falha ao ativar notificações: ${response.statusCode} ${response.body}');
        return false;
      }
    } else {
      print('Notificações desativadas pelo usuário.');
      return true;
    }
  }

  Future<void> _alternarNotificacoes(bool valor) async {
    final sucesso = await _ativarNotificacoesPush(valor);

    if (sucesso) {
      setState(() {
        _ativado = valor;
      });
      final mensagem = valor ? 'Notificações ativadas' : 'Notificações desativadas';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao atualizar o estado das notificações')));
    }
  }

  Future<void> _carregarNotificacoes() async {
    try {
      final token = await AuthController.getToken();
      if (token == null) {
        print('🔒 Usuário não autenticado.');
        return;
      }

      final user = await AuthController.obterInformacoesUsuario(token);
      if (user == null || user['id'] == null) {
        print('❌ Usuário inválido ou sem ID.');
        return;
      }

      final userId = user['id'];
      final response = await http.get(
        Uri.parse('${dotenv.env['URL_API']}/usuarios/mobile/$userId/notificacoes'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> dados = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _notificacoes = dados;
        });
      } else {
        print('❌ Erro ${response.statusCode} ao buscar notificações: ${response.body}');
      }
    } catch (e) {
      print('❌ Erro ao carregar notificações: $e');
    }
  }

  Future<void> _marcarComoLida(String userId, String notificacaoId, int index) async {
    try {
      final token = await AuthController.getToken();
      if (token == null) {
        print('🔒 Token não encontrado.');
        return;
      }

      final url = Uri.parse('${dotenv.env['URL_API']}/usuarios/mobile/$userId/notificacoes/$notificacaoId/marcar-como-lida');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        print('✅ Notificação marcada como lida.');

        setState(() {
          _notificacoes[index]['isRead'] = true;
        });
      } else {
        print('❌ Erro ao marcar como lida: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erro ao marcar notificação como lida: $e');
    }
  }

  Widget _buildNotificacao(Map<String, dynamic> n, int index) {
    return GestureDetector(
      onTap: () async {
        final token = await AuthController.getToken();
        final user = await AuthController.obterInformacoesUsuario(token!);
        if (user != null && user['id'] != null && n['isRead'] == false) {
          await _marcarComoLida(user['id'].toString(), n['id'].toString(), index);
        }
      },
      child: Card(
        color: n['isRead'] == true ? Colors.grey[200] : Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(n['titulo'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(n['corpo'] ?? '-', style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              Text(n['dataCriacao'] ?? '-', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          Row(
            children: [
              const Text('Ativar notificações', style: TextStyle(fontSize: 14, color: Colors.black54)),
              Transform.scale(
                scale: 0.65,
                child: Switch(value: _ativado, onChanged: _alternarNotificacoes),
              ),
            ],
          ),
        ],
      ),
      body: _notificacoes.isEmpty
          ? const Center(child: Text('Você ainda não possui notificações.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
        itemCount: _notificacoes.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return const SizedBox(height: 20);
          return _buildNotificacao(_notificacoes[index - 1], index - 1);
        },
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/denuncias');
              break;
            case 2:
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/noticias');
              break;
          }
        },
      ),
    );
  }
}
