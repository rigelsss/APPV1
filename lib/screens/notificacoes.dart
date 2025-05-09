import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/services/notification_service.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key, this.token});
  final String? token;

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  bool _ativado = false;
  List<dynamic> _notificacoes = [];
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _carregarEstado();
    _carregarNotificacoes();
  }

  Future<void> _carregarEstado() async {
    final ativo = await NotificationService.getNotificationsEnabled();
    setState(() {
      _ativado = ativo;
    });
  }

  Future<void> _alternarNotificacoes(bool valor) async {
    await NotificationService.setNotificationsEnabled(valor);
    await NotificationService.initialize();
    setState(() {
      _ativado = valor;
    });
    final mensagem = valor ? 'Notificações ativadas' : 'Notificações desativadas';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _carregarNotificacoes() async {
    final String jsonStr = await rootBundle.loadString('assets/json/notificacoes.json');
    final List<dynamic> dados = json.decode(jsonStr);
    setState(() {
      _notificacoes = dados;
    });
  }

  Widget _buildNotificacao(Map<String, dynamic> n) {
    return Card(
      color: Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (n['alerta'] == true)
              Row(
                children: const [
                  Text('Alerta', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  SizedBox(width: 6),
                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20),
                ],
              ),
            if (n['alerta'] == true) const SizedBox(height: 4),
            Text(n['titulo'], style: const TextStyle(color: Colors.black87, fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              '${n['data']} - ${n['hora']}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
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
          return _buildNotificacao(_notificacoes[index - 1]);
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
              Navigator.pushReplacementNamed(context, '/perfil');
              break;
          }
        },
      ),
    );
  }
}
