import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sudema_app/screens/NovaSenha.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Codigodesenha extends StatefulWidget {
  final String email;

  const Codigodesenha({super.key, required this.email});

  @override
  State<Codigodesenha> createState() => _CodigodesenhaState();
}

class _CodigodesenhaState extends State<Codigodesenha> {
  String _codigo = '';

  Future<void> _verificarCodigo() async {
    if (_codigo.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um código válido.')),
      );
      return;
    }

    final url = Uri.parse('${dotenv.env['URL_API']}/password-reset/verify-token');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'userType': 'MOBILE',
          'token': _codigo,
        }),
      );

      if (response.statusCode == 204) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Novasenha(email: widget.email, token: _codigo)),
        );
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Código inválido.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão. Tente novamente.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insira o código'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Um código de verificação foi enviado para o seu e-mail. Por favor, insira-o abaixo.\n\n'
                  'Caso não receba o código em sua caixa de entrada, verifique sua caixa de spam.\n\n'
                  'Este código é válido por até 2 horas.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            PinCodeTextField(
              appContext: context,
              length: 6,
              onChanged: (value) => _codigo = value,
              keyboardType: TextInputType.number,
              autoFocus: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                activeColor: const Color(0xFF2A2F8C),
                selectedColor: const Color(0xFF2A2F8C),
                inactiveColor: Colors.grey.shade400,
              ),
              enableActiveFill: false,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verificarCodigo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2F8C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Verificar',
                  style: GoogleFonts.lato(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Não recebeu o código?',
                style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF2A2F8C), width: 2),
                  ),
                  elevation: 4,
                ),
                child: const Text('Enviar novamente', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
