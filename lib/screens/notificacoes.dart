import 'package:flutter/material.dart';
import 'package:sudema_app/services/notification_service.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  bool _ativado = false;

  @override
  void initState() {
    super.initState();
    _carregarEstado();
  }

  Future<void> _carregarEstado() async {
    final ativo = await NotificationService.getNotificationsEnabled();
    setState(() {
      _ativado = ativo;
    });
  }

  Future<void> _alternarNotificacoes(bool valor) async {
    await NotificationService.setNotificationsEnabled(valor);
    await NotificationService.initialize(); // Solicita permissão + mostra token
    setState(() {
      _ativado = valor;
    });
    final mensagem = valor ? 'Notificações ativadas' : 'Notificações desativadas';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Ativar notificações',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              Transform.scale(
                scale: 0.65,
                child: Switch(
                  value: _ativado,
                  onChanged: _alternarNotificacoes,
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Você ainda não possui notificações.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
