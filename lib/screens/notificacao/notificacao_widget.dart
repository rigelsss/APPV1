import 'package:flutter/material.dart';
import '../fullNoticia_screen.dart'; // Confirme se exporta NoticiaCompletaPage

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
    final bool isRead = notificacao['isRead'] ?? true;
    final String titulo = notificacao['titulo'] ?? 'Sem título';
    final String corpo = notificacao['corpo'] ?? '-';
    final String dataCriacao = notificacao['createdAt'] ?? '-';
    final String tipo = notificacao['tipo'] ?? '';
    final referenciaId = notificacao['referenciaId'];

    return Card(
      color: isRead ? Colors.white : Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          print('Notificação clicada: tipo="$tipo", referenciaId=$referenciaId');
          print('Notificação completa: $notificacao');

          if (!isRead) {
            onMarcarComoLida();
          }

          if ((tipo == 'NOTICIA' || tipo.isEmpty) && referenciaId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoticiaCompletaPage(id: referenciaId.toString()),
              ),
            );
          }
          // Outros tipos não navegam
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
                dataCriacao,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
