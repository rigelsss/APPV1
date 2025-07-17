import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sudema_app/screens/TermosCondicoes.dart';
import 'package:sudema_app/screens/widgets/appbar_login.dart';
import '../login/login.dart';
import 'package:sudema_app/services/ControllerRegister.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'confirmarRegistro.dart';
import 'package:sudema_app/utils/validarcpf.dart'; 

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
  String? _erroTermos;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _contatoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  final _controller = RegistroController();
  bool _obscureText = true;
  bool _isChecked = false;

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final celularFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

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

  bool validarSenhaSegura(String senha) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~%^+=]).{8,}$');
    return regex.hasMatch(senha);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDenuncia(title: 'Cadastro'),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    campoComErro("Nome completo", _nomeController, TextInputType.text, "Nome completo", _erroNome),
                    campoComErro("CPF", _cpfController, TextInputType.number, "000.000.000-00", _erroCpf, formatter: cpfFormatter),
                    campoComErro("Contato", _contatoController, TextInputType.phone, "(00)00000-0000", _erroContato, formatter: celularFormatter),
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
                    SizedBox(height: 8),
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
                            'Declaro que as informações acima prestadas são verdadeiras, e assumo a inteira responsabilidade pelas mesmas.',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    if (_erroTermos != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          _erroTermos!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
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
                                color: Color(0xFF2A2F8C),
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
                          final cpf = cpfFormatter.getUnmaskedText();

                          setState(() {
                            _erroNome = _nomeController.text.trim().split(' ').length < 2
                                ? 'Digite o nome completo (nome e sobrenome)'
                                : null;

                            _erroCpf = cpf.isEmpty
                                ? 'CPF é obrigatório'
                                : (!validarCPF(cpf) ? 'CPF inválido' : null); 

                            _erroContato = _contatoController.text.isEmpty ? 'Contato é obrigatório' : null;
                            _erroEmail = _emailController.text.isEmpty ? 'E-mail é obrigatório' : null;
                            _erroSenha = _senhaController.text.isEmpty
                                ? 'Senha é obrigatória'
                                : !validarSenhaSegura(_senhaController.text)
                                    ? 'A senha deve ter no mínimo 8 caracteres, incluir letras, números e caracteres especiais.'
                                    : null;
                            _erroConfirmarSenha = _confirmarSenhaController.text.isEmpty ? 'Confirmação de senha é obrigatória' : null;
                            _erroTermos = !_isChecked ? 'Você deve aceitar os termos para continuar.' : null;
                          });

                          if (_erroNome != null ||
                              _erroCpf != null ||
                              _erroContato != null ||
                              _erroEmail != null ||
                              _erroSenha != null ||
                              _erroConfirmarSenha != null ||
                              _erroTermos != null) {
                            Flushbar(
                              flushbarPosition: FlushbarPosition.TOP,
                              duration: Duration(seconds: 3),
                              backgroundColor: Color(0xFFF8DFDD),
                              icon: SvgPicture.asset(
                                'assets/icon/x-circle.svg',
                                width: 28,
                                height: 28,
                                color: Colors.red,
                              ),
                              messageText: Text(
                                'Preencha todos os campos obrigatórios.',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
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
                            cpf: cpf,
                            telefone: celularFormatter.getUnmaskedText(),
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
                              MaterialPageRoute(builder: (context) => CodigoRegistro(email: _emailController.text)),
                            );
                          } else {
                            setState(() {
                              if (resultado.toLowerCase().contains('cpf')) {
                                _erroCpf = resultado;
                              }else {
                                _erroEmail = resultado;
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(resultado)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1B8C00),
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 140),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Criar Conta',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
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
            ),
          );
        },
      ),
    );
  }

  Widget campoComErro(String label, TextEditingController controller, TextInputType type, String hint, String? erro,
      {MaskTextInputFormatter? formatter}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          TextField(
            controller: controller,
            keyboardType: type,
            inputFormatters: formatter != null ? [formatter] : [],
            decoration: InputDecoration(
              hintText: hint,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
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

  Widget campoSenha(String label, TextEditingController controller, String? erro) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 18)),
          TextField(
            controller: controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
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
