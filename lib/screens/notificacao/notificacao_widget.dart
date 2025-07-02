import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../noticias/pagina_noticiaCompleta/noticiaCompleta_screen.dart';

class NotificacaoWidget extends StatelessWidget {
  final Map<String, dynamic> notificacao;
  final int index;
  final VoidCallback onMarcarComoLida;

  const NotificacaoWidget({
    super.key,
    required this.notificacao,
    required this.index,
    required this.onMarcarComoLida,
  });

  @override
  Widget build(BuildContext context) {
    print('DEBUG Notificação $index: $notificacao');

    final bool isRead = notificacao['isRead'] ?? true;
    final String titulo = notificacao['titulo'] ?? 'Sem título';
    final String corpo = notificacao['corpo'] ?? '-';
    final String tipo = notificacao['tipo'] ?? notificacao['tipoNotificacao'] ?? '';
    final referenciaId = notificacao['referenciaId'];

    final String dataFormatada = () {
      try {
        final raw = notificacao['dataCriacao'];
        if (raw == null || raw is! String) return '-';
        final data = DateFormat('dd/MM/yyyy HH:mm:ss').parse(raw);
        return DateFormat('dd/MM/yyyy HH:mm').format(data);
      } catch (e) {
        return '-';
      }
    }();

    return Card(
      color: isRead ? Colors.white : Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          if (!isRead) {
            onMarcarComoLida();
          }

          if ((tipo == 'NOTICIA' || tipo == 'NOVA_NOTICIA') && referenciaId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoticiaCompletaPage(id: referenciaId.toString()),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                corpo,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                dataFormatada,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
