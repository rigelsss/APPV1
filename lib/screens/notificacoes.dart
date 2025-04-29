import 'package:flutter/material.dart';

class NotificacoesPage extends StatelessWidget {
  const NotificacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
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
