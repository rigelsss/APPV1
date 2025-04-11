import 'package:flutter/material.dart';

class NovaDenunciaPage extends StatelessWidget {
  const NovaDenunciaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Denúncia'),
      ),
      body: const Center(
        child: Text('Aqui será o formulário de denúncia'),
      ),
    );
  }
}
