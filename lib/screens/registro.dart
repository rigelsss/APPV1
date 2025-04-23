import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:sudema_app/screens/TermosCondicoes.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/appbardenuncia.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _obscureText = true;
  bool _isChecked = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _contatoController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDenuncia(title: 'Cadastro'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _nomeController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('CPF', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _cpfController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Contato', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _contatoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            Text('E-mail', style: TextStyle(fontSize: 18)),
            TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder())),
            SizedBox(height: 20),
            Text('Senha', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _senhaController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Declaro que as informações acima prestadas são verdadeiras, e assumo a inteira responsabilidade pelas mesmas.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Ao usar este aplicativo você concorda com os',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: ' Termos e Condições',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Termoscondicoes(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Verifica se todos os campos estão preenchidos
                  if (_nomeController.text.trim().isEmpty ||
                      _cpfController.text.trim().isEmpty ||
                      _contatoController.text.trim().isEmpty ||
                      _emailController.text.trim().isEmpty ||
                      _senhaController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Todos os campos são obrigatórios.')),
                    );
                    return;
                  }

                  if (!_isChecked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Você precisa aceitar os termos para continuar.')),
                    );
                    return;
                  }

                  print('Dados de cadastro:');
                  print('Nome: ${_nomeController.text}');
                  print('CPF: ${_cpfController.text}');
                  print('E-mail: ${_emailController.text}');
                  print('Telefone: ${_contatoController.text}');
                  print('Senha: ${_senhaController.text}');

                  // Ajuste da URL dependendo do ambiente
                  final url = Uri.parse('http://10.0.2.2:9000/auth/register'); // Para emulador Android
                  // final url = Uri.parse('http://<seu-ip-local>:9000/auth/register'); // Para dispositivo físico

                  try {
                    final response = await http.post(
                      url,
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode({
                        'name': _nomeController.text.trim(),
                        'cpf': _cpfController.text.trim(),
                        'email': _emailController.text.trim(),
                        'phone': _contatoController.text.trim(),
                        'password': _senhaController.text.trim(),
                        "userType": "MOBILE"
                      }),
                    );

                    if (response.statusCode == 200 || response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cadastro realizado com sucesso!')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao cadastrar. Verifique os dados e tente novamente.')),
                      );
                      print('Erro no cadastro: ${response.statusCode}');
                      print('Resposta: ${response.body}');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erro de conexão. Tente novamente.')),
                    );
                    print('Erro de conexão: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 140),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Criar Conta',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Já possui uma conta? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    TextSpan(
                      text: 'Faça login',
                      style: TextStyle(
                        color: Color(0xFF2A2F8C),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
