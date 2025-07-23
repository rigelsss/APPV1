import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sudema_app/screens/diversos/TermosCondicoes.dart';
import 'package:sudema_app/screens/login/login.dart';
import 'package:sudema_app/screens/cadastro/confirmar_cadastro.dart';
import 'package:sudema_app/screens/cadastro/controller/cadastro_controller.dart';
import 'package:sudema_app/utils/validarcpf.dart';
import 'package:sudema_app/screens/cadastro/widgets/form_fields.dart';

class CadastroForm extends StatefulWidget {
  const CadastroForm({super.key});

  @override
  State<CadastroForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  final _controller = RegistroController();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _contatoController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  String? _erroNome;
  String? _erroCpf;
  String? _erroContato;
  String? _erroEmail;
  String? _erroSenha;
  String? _erroConfirmarSenha;
  String? _erroTermos;

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

  bool validarSenhaSegura(String senha) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~%^+=]).{8,}$');
    return regex.hasMatch(senha);
  }

  void _mostrarErroFlush(String mensagem) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: const Color(0xFFF8DFDD),
      icon: SvgPicture.asset(
        'assets/icon/x-circle.svg',
        width: 28,
        height: 28,
        color: Colors.red,
      ),
      messageText: Text(
        mensagem,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    ).show(context);
  }

  void _submeter() async {
    final cpf = cpfFormatter.getUnmaskedText();

    setState(() {
      _erroNome = _nomeController.text.trim().split(' ').length < 2 ? 'Digite o nome completo (nome e sobrenome)' : null;
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

    if (_erroNome != null || _erroCpf != null || _erroContato != null || _erroEmail != null || _erroSenha != null || _erroConfirmarSenha != null || _erroTermos != null) {
      _mostrarErroFlush('Preencha todos os campos obrigatórios.');
      return;
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
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
      Flushbar(
        backgroundColor: const Color(0xFFD2FDE6),
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(12),
        margin: const EdgeInsets.all(12),
        messageText: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cadastro realizado com sucesso!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B8C00),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Enviamos um código de verificação para seu e-mail.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1B8C00),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ).show(context);

      await Future.delayed(const Duration(milliseconds: 2500));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CodigoRegistro(email: _emailController.text)),
      );

    } else {
      setState(() {
        if (resultado.toLowerCase().contains('cpf')) {
          _erroCpf = resultado;
        } else {
          _erroEmail = resultado;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CampoTextoPadrao(
          label: "Nome completo",
          controller: _nomeController,
          keyboardType: TextInputType.text,
          hint: "Nome completo",
          erro: _erroNome,
        ),
        CampoTextoPadrao(
          label: "CPF",
          controller: _cpfController,
          keyboardType: TextInputType.number,
          hint: "000.000.000-00",
          erro: _erroCpf,
          formatters: [cpfFormatter],
        ),
        CampoTextoPadrao(
          label: "Contato",
          controller: _contatoController,
          keyboardType: TextInputType.phone,
          hint: "(00)00000-0000",
          erro: _erroContato,
          formatters: [celularFormatter],
        ),
        CampoTextoPadrao(
          label: "E-mail",
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          hint: "exemplo@exemplo.com",
          erro: _erroEmail,
        ),
        CampoSenha(
          label: "Senha",
          controller: _senhaController,
          erro: _erroSenha,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            'A senha deve ter no mínimo 8 caracteres e conter letras, números e caracteres especiais',
            style: TextStyle(fontSize: 14, color: Color(0xFF747474)),
          ),
        ),
        CampoSenha(
          label: "Confirme sua senha",
          controller: _confirmarSenhaController,
          erro: _erroConfirmarSenha,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Checkbox(
              activeColor: const Color(0xFF2A2F8C),
              value: _isChecked,
              shape: const CircleBorder(),
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
            ),
            const Expanded(
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
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 20),
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Ao usar este aplicativo você concorda com os',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                TextSpan(
                  text: ' Termos e Condições',
                  style: const TextStyle(
                    color: Color(0xFF2A2F8C),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Termoscondicoes()),
                      );
                    },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _submeter,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B8C00),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 140),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Criar Conta',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Já possui uma conta? ',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                TextSpan(
                  text: 'Faça login',
                  style: const TextStyle(
                    color: Color(0xFF2A2F8C),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                    },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
