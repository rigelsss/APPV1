import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/services/AuthMe.dart';

class Identificacao extends StatefulWidget {
  final VoidCallback onAvancar;

  const Identificacao({super.key, required this.onAvancar});

  @override
  State<Identificacao> createState() => _AbaIdentificacaoState();
}

class _AbaIdentificacaoState extends State<Identificacao> {
  String? usuarioEmail = '';
  bool _logado = false;
  bool _anonimo = false;

  @override
  void initState() {
    super.initState();
    _verificarLogin();
  }

  Future<void> _verificarLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token != null && !JwtDecoder.isExpired(token)) {
    final dadosUsuario = await AuthController.obterInformacoesUsuario(token);

    if (dadosUsuario != null && dadosUsuario['email'] != null) {
      setState(() {
        _logado = true;
        usuarioEmail = dadosUsuario['email'];
        _anonimo = false;
        DenunciaData().usuarioEmail = usuarioEmail;
      });
    } else {
      print('⚠️ Email não encontrado nos dados do usuário');
    }
  } else {
    print('⚠️ Token inválido ou expirado');
  }
}


  void _selecionarAnonimo() {
    setState(() {
      _anonimo = true;
      DenunciaData().anonimo = true;
    });
    widget.onAvancar();
  }

  void _selecionarIdentificado() {
    setState(() {
      _anonimo = false;
      DenunciaData().anonimo = false;
    });
    widget.onAvancar();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Identificação',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          if (!_logado)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'É necessário acessar o sistema para realizar uma denúncia. Após o login você pode escolher fazer a denúncia de forma anônima.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2F8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Fazer login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Você acessou o sistema como $usuarioEmail.',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _selecionarIdentificado,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _anonimo ? Colors.white : const Color(0xFF2A2F8C),
                      foregroundColor:
                          _anonimo ? const Color(0xFF2A2F8C) : Colors.white,
                      side: const BorderSide(
                        color: Color(0xFF2A2F8C),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Prosseguir com identificação'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _selecionarAnonimo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _anonimo ? const Color(0xFF2A2F8C) : Colors.white,
                      foregroundColor:
                          _anonimo ? Colors.white : const Color(0xFF2A2F8C),
                      side: const BorderSide(
                        color: Color(0xFF2A2F8C),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Continuar de forma anônima'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
