import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/CodigoDeSenha.dart';
import 'package:sudema_app/screens/widgets/appbardenuncia.dart';

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

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  Future<void> _enviarEmailDeRecuperacao(String email) async {
    final url = Uri.parse('${dotenv.env['URL_API']}/password-reset/forgot-password');
    print('Chamando endpoint: $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código enviado para o e-mail informado.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navegar para a próxima tela
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Codigodesenha()),
        );
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Erro ao enviar e-mail.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Erro de conexão: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro de conexão. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarDenuncia(title: 'Recuperação de Senha'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Informe o e-mail associado à sua conta para alteração de senha.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'E-mail',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String email = _emailController.text.trim();

                  if (email.isEmpty || !_isValidEmail(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor, insira um e-mail válido.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  _enviarEmailDeRecuperacao(email);
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
