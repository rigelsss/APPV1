import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/perfil/menu/CodigoDeSenha.dart';
import 'package:sudema_app/screens/widgets/appbardenuncia.dart';

class Recuperacaoosenha extends StatefulWidget {
  const Recuperacaoosenha({super.key});

  @override
  State<Recuperacaoosenha> createState() => _RecuperacaoosenhaState();
}

class _RecuperacaoosenhaState extends State<Recuperacaoosenha> {
  final TextEditingController _emailController = TextEditingController();
  String? _erroEmail;

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
        body: jsonEncode({
          'email': email,
          'userType': 'MOBILE',
        }),
      );
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _erroEmail = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Código enviado para o e-mail informado.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Codigodesenha(email: email)),
        );
      } else if (response.statusCode == 400) {
        setState(() {
          _erroEmail = 'Este e-mail não está cadastrado em nosso sistema.';
        });
      } else {
        setState(() {
          _erroEmail = null;
        });

        try {
          final error = jsonDecode(response.body)['message'] ?? 'Erro ao enviar e-mail.';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        } catch (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao enviar e-mail.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _erroEmail = null;
      });

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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarDenuncia(title: 'Recuperação de senha'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 500 ? 16 : screenWidth * 0.15,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informe o e-mail associado à sua conta para alteração de senha.',
                  style: GoogleFonts.lato(fontSize: 16),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                    errorText: _erroEmail,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _erroEmail != null ? Colors.red : Colors.grey),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    if (_erroEmail != null) {
                      setState(() {
                        _erroEmail = null;
                      });
                    }
                  },
                ),
                SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String email = _emailController.text.trim();

                        if (email.isEmpty || !_isValidEmail(email)) {
                          setState(() {
                            _erroEmail = 'Por favor, insira um e-mail válido.';
                          });
                          return;
                        }

                        _enviarEmailDeRecuperacao(email);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2F8C),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Enviar código de verificação',
                        style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
