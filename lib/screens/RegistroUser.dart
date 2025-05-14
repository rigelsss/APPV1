import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:sudema_app/screens/TermosCondicoes.dart';
import 'package:sudema_app/screens/widgets/appbardenuncia.dart';
import 'login.dart';
import 'package:sudema_app/services/ControllerRegister.dart';
import 'package:another_flushbar/flushbar.dart';

class RegistroUser extends StatefulWidget {
  const RegistroUser({super.key});

  @override
  State<RegistroUser> createState() => _RegistroUserState();
}

class _RegistroUserState extends State<RegistroUser> {
  String? _erroNome;
  String? _erroCpf;
  String? _erroContato;
  String? _erroEmail;
  String? _erroSenha;
  String? _erroConfirmarSenha;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  final _controller = RegistroController();
  bool _obscureText = true;
  bool _isChecked = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _contatoController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDenuncia(title: 'Cadastro'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            campoComErro("Nome", _nomeController, TextInputType.text, "Nome de usuário", _erroNome),
            campoComErro("CPF", _cpfController, TextInputType.number, "000.000.000-00", _erroCpf),
            campoComErro("Contato", _contatoController, TextInputType.phone, "(00)00000-0000", _erroContato),
            campoComErro("E-mail", _emailController, TextInputType.emailAddress, "exemplo@exemplo.com", _erroEmail),
            campoSenha("Senha", _senhaController, _erroSenha),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                'A senha deve ter no mínimo 8 caracteres e conter letras, números e caracteres especiais',
                style: TextStyle(fontSize: 14, color: Color(0xFF747474)),
              ),
            ),
            campoSenha("Confirme sua senha", _confirmarSenhaController, _erroConfirmarSenha),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _isChecked,
                  shape: const CircleBorder(),
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Declaro que as informações acima prestadas são verdadeiras...',
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
                      style: TextStyle(color: Colors.black, fontSize: 12),
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
                  setState(() {
                    _erroNome = _nomeController.text.isEmpty ? 'Nome é obrigatório' : null;
                    _erroCpf = _cpfController.text.isEmpty ? 'CPF é obrigatório' : null;
                    _erroContato = _contatoController.text.isEmpty ? 'Contato é obrigatório' : null;
                    _erroEmail = _emailController.text.isEmpty ? 'E-mail é obrigatório' : null;
                    _erroSenha = _senhaController.text.isEmpty ? 'Senha é obrigatória' : null;
                    _erroConfirmarSenha = _confirmarSenhaController.text.isEmpty ? 'Confirmação de senha é obrigatória' : null;
                  });

                  if (_erroNome != null ||
                      _erroCpf != null ||
                      _erroContato != null ||
                      _erroEmail != null ||
                      _erroSenha != null ||
                      _erroConfirmarSenha != null) {
                    Flushbar(
                      message: 'Preencha todos os campos obrigatórios.',
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.red,
                      flushbarPosition: FlushbarPosition.TOP,
                      icon: Icon(Icons.error, color: Colors.white),
                    ).show(context);
                    return;
                  }

                  if (_senhaController.text != _confirmarSenhaController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('As senhas não coincidem.')),
                    );
                    return;
                  }

                  final resultado = await _controller.validarERegistrar(
                    nome: _nomeController.text,
                    cpf: _cpfController.text,
                    telefone: _contatoController.text,
                    email: _emailController.text,
                    senha: _senhaController.text,
                    aceitouTermos: _isChecked,
                  );

                  if (resultado == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cadastro realizado com sucesso!')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(resultado)),
                    );
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
                      style: TextStyle(color: Colors.black, fontSize: 18),
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

  Widget campoComErro(String label, TextEditingController controller, TextInputType type, String hint, String? erro) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          TextField(
            controller: controller,
            keyboardType: type,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hint,
            ),
          ),
          if (erro != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                erro,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget campoSenha(String label, TextEditingController controller, String? erro) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          TextField(
            controller: controller,
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
          if (erro != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                erro,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
