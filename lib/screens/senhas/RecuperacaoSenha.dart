import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:sudema_app/screens/senhas/CodigoDeSenha.dart';
import 'package:sudema_app/screens/widgets/appbar_login.dart';

enum TipoMensagem { sucesso, erro, aviso }

class RecuperacaoSenha extends StatefulWidget {
  const RecuperacaoSenha({super.key});

  @override
  State<RecuperacaoSenha> createState() => _RecuperacaoSenhaState();
}

class _RecuperacaoSenhaState extends State<RecuperacaoSenha> {
  final TextEditingController _emailController = TextEditingController();
  String? _erroEmail;

  static const Color _primaryColor = Color(0xFF2A2F8C);
  static const double _smallScreenWidth = 500;
  static const String _userType = 'MOBILE';

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
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'userType': _userType}),
      );
      _processarResposta(response, email);
    } catch (e) {
      debugPrint('Erro ao enviar solicitação: $e');
      _mostrarErroConexao();
    }
  }

  void _processarResposta(http.Response response, String email) {
    if (response.statusCode == 200 || response.statusCode == 204) {
      _processarRespostaSucesso(email);
    } else if (response.statusCode == 400) {
      _definirErroEmail('Este e-mail não está cadastrado em nosso sistema.');
    } else {
      _processarRespostaErro(response);
    }
  }

  void _processarRespostaSucesso(String email) {
    _limparErroEmail();
    _mostrarFlushbarPadrao('Código enviado para o e-mail informado.', TipoMensagem.sucesso);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Codigodesenha(email: email)),
    );
  }

  void _processarRespostaErro(http.Response response) {
    _limparErroEmail();
    try {
      final error = jsonDecode(response.body)['message'] ?? 'Erro ao enviar e-mail.';
      _mostrarFlushbarPadrao(error, TipoMensagem.erro);
    } catch (_) {
      _mostrarFlushbarPadrao('Erro ao enviar e-mail.', TipoMensagem.erro);
    }
  }

  void _mostrarErroConexao() {
    _limparErroEmail();
    _mostrarFlushbarPadrao('Erro de conexão. Tente novamente.', TipoMensagem.erro);
  }

  void _definirErroEmail(String erro) {
    setState(() {
      _erroEmail = erro;
    });
  }

  void _limparErroEmail() {
    setState(() {
      _erroEmail = null;
    });
  }

  void _validarEEnviarEmail() {
    String email = _emailController.text.trim();

    if (email.isEmpty || !_isValidEmail(email)) {
      _definirErroEmail('Por favor, insira um e-mail válido.');
      return;
    }

    _enviarEmailDeRecuperacao(email);
  }

  Widget _buildEmailTextField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelText: 'E-mail',
        errorText: _erroEmail,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _erroEmail != null ? Colors.red : Colors.grey,
          ),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: (_) {
        if (_erroEmail != null) {
          _limparErroEmail();
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _validarEEnviarEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarDenuncia(title: 'Recuperação de senha'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final content = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isTablet ? CrossAxisAlignment.center : CrossAxisAlignment.start, // <-- centraliza horizontalmente
            children: [
              Text(
                'Informe o e-mail associado à sua conta para alteração de senha.',
                style: GoogleFonts.lato(fontSize: 16),
                textAlign: isTablet ? TextAlign.center : TextAlign.start,
              ),
              SizedBox(height: 20),
              _buildEmailTextField(),
              SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          );

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 16,
              vertical: isTablet ? 0 : 24,
            ),
            child: isTablet
                ? Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 500,
                  minHeight: constraints.maxHeight,
                ),
                child: Center(child: content), // centraliza vertical e horizontal
              ),
            )
                : content,
          );
        },
      ),
    );
  }


  void _mostrarFlushbarPadrao(String mensagem, TipoMensagem tipo) {
    Color cor;
    Icon icone;

    switch (tipo) {
      case TipoMensagem.sucesso:
        cor = Colors.green;
        icone = Icon(Icons.check_circle, color: Colors.white);
        break;
      case TipoMensagem.erro:
        cor = Colors.red;
        icone = Icon(Icons.error, color: Colors.white);
        break;
      case TipoMensagem.aviso:
        cor = Colors.orange;
        icone = Icon(Icons.warning, color: Colors.white);
        break;
    }

    Flushbar(
      message: mensagem,
      duration: Duration(seconds: 3),
      backgroundColor: cor,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(16),
      animationDuration: Duration(milliseconds: 500),
      icon: icone,
    ).show(context);
  }
}
