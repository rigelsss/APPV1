import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:another_flushbar/flushbar.dart';

import 'package:sudema_app/services/AuthMe.dart';
import 'package:sudema_app/screens/widgets/drawer.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'perfil_page.dart';

class EditarEmail extends StatefulWidget {
  const EditarEmail({super.key});

  @override
  State<EditarEmail> createState() => _EditarEmailState();
}

class _EditarEmailState extends State<EditarEmail> {
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _novoEmailController = TextEditingController();
  final TextEditingController _confirmarEmailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  int _currentIndex = -1;

  void _exibirErro(String mensagem) {
    Flushbar(
      title: 'Verifique suas credenciais',
      message: mensagem,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red.shade600,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(10),
      margin: const EdgeInsets.all(8),
    ).show(context);
  }

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/denuncias');
        break;
      case 2:
        Navigator.pushNamed(context, '/praias');
        break;
      case 3:
        Navigator.pushNamed(context, '/noticias');
        break;
    }
  }

  Future<void> _confirmarAlteracao() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _exibirErro('Usuário não autenticado.');
      return;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final id = decodedToken['id'];

    final baseUrl = dotenv.env['URL_API'];
    final url = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "senhaAtual": _senhaController.text.trim(),
        "novoEmail": _novoEmailController.text.trim(),
        "confirmacaoEmail": _confirmarEmailController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      try {
        final responseBody = jsonDecode(response.body);
        final novoToken = responseBody['token'];

        if (novoToken != null && novoToken is String) {
          await AuthController.updateToken(novoToken);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-mail alterado com sucesso!')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Perfiluser(token: novoToken)),
          );
        } else {
          _exibirErro('Token não recebido. Tente novamente.');
        }
      } catch (_) {
        _exibirErro('Erro ao processar resposta do servidor.');
      }
    } else {
      if (response.body.isNotEmpty) {
        try {
          final responseBody = jsonDecode(response.body);
          final errors = responseBody['errors'];

          if (errors is List && errors.isNotEmpty) {
            final mensagem = errors[0]['message'];
            if (mensagem == 'Senha atual incorreta') {
              _exibirErro('A senha informada está incorreta.');
            } else if (mensagem == 'E-mail já cadastrado') {
              _exibirErro('Este e-mail já está em uso. Tente outro.');
            } else {
              _exibirErro(mensagem);
            }
          } else {
            _exibirErro('Erro ao alterar e-mail. Tente novamente.');
          }
        } catch (_) {
          _exibirErro('Erro inesperado. Tente novamente.');
        }
      } else {
        _exibirErro('Erro ao alterar e-mail. '
            'Status: ${response.statusCode}. ${response.reasonPhrase ?? ''}');
      }
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.green.shade700, width: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Alterar e-mail', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Senha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _senhaController,
                obscureText: _obscureText,
                decoration: _inputDecoration().copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a senha atual' : null,
              ),
              const SizedBox(height: 24),
              const Text('Novo e-mail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _novoEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o novo e-mail' : null,
              ),
              const SizedBox(height: 24),
              const Text('Confirme o novo e-mail',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmarEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Confirme o novo e-mail';
                  if (value != _novoEmailController.text) return 'Os e-mails não coincidem';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmarAlteracao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8C00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Confirmar alteração de e-mail',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
