import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final valor = prefs.getBool('notificacoes_ativadas') ?? true;
    setState(() {
      _ativado = valor;
    });
  }

  Future<void> _alternarNotificacoes(bool valor) async {
    final sucesso = await NotificacoesService.ativarNotificacoesPush(valor);

    if (sucesso) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificacoes_ativadas', valor);

      setState(() => _ativado = valor);

      final cor = valor ? const Color(0xFF1B8C00) : const Color(0xFFD32F2F);
      final titulo = valor ? 'Notificações ativadas!' : 'Notificações desativadas!';
      final subtitulo = valor
          ? 'Agora você receberá alertas e novidades da SUDEMA.'
          : 'Você não receberá mais notificações do app.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          elevation: 6,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Icon(
                valor ? Icons.check_circle_rounded : Icons.notifications_off_rounded,
                color: cor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        fontSize: 14,
                        color: cor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao atualizar as notificações. Tente novamente.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _carregarNotificacoes() async {
    final lista = await NotificacoesService.carregarNotificacoes();
    if (lista != null) {
      lista.sort((a, b) {
        int idA = int.tryParse(a['id'].toString()) ?? 0;
        int idB = int.tryParse(b['id'].toString()) ?? 0;
        return idB.compareTo(idA);
      });

      if (lista.length > 20) {
        lista.removeRange(20, lista.length);
      }

      setState(() {
        _notificacoes = lista;
      });

      for (int i = 0; i < lista.length; i++) {
        if (lista[i]['isRead'] == false) {
          await NotificacoesService.marcarComoLida(
            lista[i]['id'].toString(),
            i,
            _notificacoes,
                () {
              setState(() {});
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600; // você pode ajustar esse breakpoint

    Widget bodyContent = _notificacoes.isEmpty
        ? const Center(
      child: Text(
        'Você ainda não possui notificações.',
        style: TextStyle(fontSize: 18),
      ),
    )
        : ListView.builder(
      itemCount: _notificacoes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return const SizedBox(height: 20);
        final notificacao = _notificacoes[index - 1];
        return NotificacaoWidget(
          notificacao: notificacao,
          index: index - 1,
          onMarcarComoLida: () async {
            await NotificacoesService.marcarComoLida(
              notificacao['id'].toString(),
              index - 1,
              _notificacoes,
                  () {
                setState(() {});
              },
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        titleSpacing: 0,
        title: Text(
          'Notificações',
          style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w400),
        ),
        actions: [
          Row(
            children: [
              const Text('Ativar notificações',
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
              Transform.scale(
                scale: 0.65,
                child: Switch(value: _ativado, onChanged: _alternarNotificacoes),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isTablet
          ? Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: bodyContent,
        ),
      )
          : bodyContent,
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
