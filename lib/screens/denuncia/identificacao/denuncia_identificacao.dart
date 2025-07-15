import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:google_fonts/google_fonts.dart';

class Identificacao extends StatefulWidget {
  final VoidCallback onAvancar;

  const Identificacao({super.key, required this.onAvancar});

  @override
  State<Identificacao> createState() => _AbaIdentificacaoState();
}

class _AbaIdentificacaoState extends State<Identificacao> {
  String? usuarioEmail;
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
      DenunciaData().identificacaoConfirmada = false;
    });
    widget.onAvancar();
  }

  void _selecionarIdentificado() {
    setState(() {
      _anonimo = false;
      DenunciaData().anonimo = false;
      DenunciaData().identificacaoConfirmada = true;
    });
    widget.onAvancar();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Identificação',
            style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(height: 24),
          if (!_logado)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'É necessário acessar o sistema para realizar uma denúncia. Após o login você pode escolher fazer a denúncia de forma anônima.',
                  style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/login',
                        arguments: {'voltarPara': '/denuncia'},
                      );;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2F8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:  Text(
                      'Acessar o sistema',
                      style: GoogleFonts.lato(fontSize: 16, color:Colors.white),
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Você acessou o sistema como ',
                        style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w300)
                      ),
                      TextSpan(
                        text: usuarioEmail ?? '',
                        style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 58,
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text('Prosseguir com identificação', style: GoogleFonts.lato(fontSize:16)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 58,
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child:  Text('Continuar de forma anônima', style:GoogleFonts.lato(fontSize:16) ,),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
