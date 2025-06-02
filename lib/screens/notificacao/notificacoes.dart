import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';


import 'notificacao_service.dart';
import 'notificacao_widget.dart';

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
    NotificacoesService.solicitarPermissaoNotificacoes();
    _carregarEstado();
    _carregarNotificacoes();
  }

  Future<void> _carregarEstado() async {
    setState(() {
      _ativado = true;
    });
  }

  Future<void> _alternarNotificacoes(bool valor) async {
    final sucesso = await NotificacoesService.ativarNotificacoesPush(valor);

    if (sucesso) {
      setState(() => _ativado = valor);
      final mensagem = valor ? 'Notificações ativadas' : 'Notificações desativadas';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao atualizar o estado das notificações')),
      );
    }
  }

  Future<void> _carregarNotificacoes() async {
    final lista = await NotificacoesService.carregarNotificacoes();
    if (lista != null) {
      lista.sort((a, b) {
        if (a['isRead'] == b['isRead']) {
          DateTime dataA = DateTime.tryParse(a['dataCriacao'] ?? '') ?? DateTime(0);
          DateTime dataB = DateTime.tryParse(b['dataCriacao'] ?? '') ?? DateTime(0);
          return dataB.compareTo(dataA);
        }
        return (a['isRead'] == false) ? -1 : 1;
      });
      setState(() {
        _notificacoes = lista;
      });
    }
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
          final notificacao = _notificacoes[index - 1];
          return NotificacaoWidget(
            notificacao: notificacao,
            index: index - 1,
            onMarcarComoLida: () async {
              await NotificacoesService.marcarComoLida(notificacao['id'], index - 1, _notificacoes, () {
                setState(() {});
              });
            },
          );
        },
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/denuncias');
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
