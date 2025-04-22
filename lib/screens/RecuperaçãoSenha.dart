import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/appbardenuncia.dart';

class Recuperacaoosenha extends StatefulWidget {
  const Recuperacaoosenha({super.key});

  @override
  State<Recuperacaoosenha> createState() => _RecuperacaoosenhaState();
}

class _RecuperacaoosenhaState extends State<Recuperacaoosenha> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDenuncia(title: 'Recuperação de Senha'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Informe o e-mail associado à sua conta para alteração de senha.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Exemplo de ação ao clicar:
                  String email = _emailController.text.trim();
                  print('Email inserido: $email');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2F8C),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Enviar Código de Verificação',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
