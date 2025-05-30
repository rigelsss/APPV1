import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: () {
        if (notificacao['isRead'] == false) {
          onMarcarComoLida();
        }
      },
      child: Card(
        color: notificacao['isRead'] == true ? Colors.white : Colors.grey[300],
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notificacao['titulo'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                notificacao['corpo'] ?? '-',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 6),
              Text(
                notificacao['dataCriacao'] ?? '-',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
