import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sudema_app/screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';

class CodigoRegistro extends StatefulWidget {
  final String email;
  const CodigoRegistro({super.key, required this.email});

  @override
  State<CodigoRegistro> createState() => _CodigoRegistroState();
}

class _CodigoRegistroState extends State<CodigoRegistro> {
  String _token = '';
  bool _isLoading = false;

  void _confirmarCodigo() async {
    if (_token.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o código de 6 dígitos.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    void _mostrarErroFlushbar(String mensagem) {
      Flushbar(
        duration: const Duration(seconds: 4),
        backgroundColor: const Color(0xFFF8DFDD),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(12),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        icon: SvgPicture.asset(
          'assets/icon/x-circle.svg',
          width: 28,
          height: 28,
          color: Color(0xFFAC5A5A),
        ),
        messageText: Text(
          mensagem,
          style: const TextStyle(
            color: Color(0xFFAC5A5A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ).show(context);
    }


    final url = Uri.parse('${dotenv.env['URL_API']}/auth/register/confirm');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": widget.email,
        "userType": "MOBILE",
        "token": _token
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      String errorMsg = "Erro ao confirmar o código.";
      try {
        final data = jsonDecode(response.body);
        if (data is String) {
          errorMsg = data;
        } else if (data['message'] != null) {
          errorMsg = data['message'];
        } else if (data['token'] != null) {
          errorMsg = data['token'];
        }
      } catch (_) {}
      _mostrarErroFlushbar(errorMsg);
    } else if (response.statusCode == 500) {
      _mostrarErroFlushbar("Erro interno do servidor. Tente novamente mais tarde.");
    } else {
      _mostrarErroFlushbar("Erro desconhecido. Código: ${response.statusCode}");
    }
  }

  void _reenviarCodigo() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${dotenv.env['URL_API']}/auth/register/resend-confirm');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": widget.email,
        "userType": "MOBILE"
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código reenviado com sucesso! Verifique seu e-mail.')),
      );
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      String errorMsg = "Erro ao reenviar o código.";
      try {
        final data = jsonDecode(response.body);
        if (data is String) {
          errorMsg = data;
        } else if (data['message'] != null) {
          errorMsg = data['message'];
        }
      } catch (_) {}
      _showErrorDialog(errorMsg);
    } else if (response.statusCode == 500) {
      _showErrorDialog("Erro interno do servidor. Tente novamente mais tarde.");
    } else {
      _showErrorDialog("Erro desconhecido. Código: ${response.statusCode}");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erro"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isSmallScreen = width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Conta'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : width * 0.1,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Um código de verificação foi enviado para o seu e-mail. Por favor, insira-o abaixo.\n\n'
                  'Caso não receba o código em sua caixa de entrada, verifique sua caixa de spam.\n\n'
                  'Este código é válido por até 2 horas.',
              style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
            ),
            const SizedBox(height: 30),
            PinCodeTextField(
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              autoFocus: true,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: isSmallScreen ? 50 : 60,
                fieldWidth: isSmallScreen ? 40 : 50,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                activeColor: const Color(0xFF2A2F8C),
                selectedColor: const Color(0xFF2A2F8C),
                inactiveColor: Colors.grey.shade400,
              ),
              enableActiveFill: false,
              onChanged: (value) {setState(() {
                _token = value;
              });},
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2F8C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  _confirmarCodigo();
                },
                child: Text(
                  'Verificar',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Expanded(
                  child: Divider(thickness: 1, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Não recebeu o código?',
                    style: TextStyle(
                      color: const Color(0xFF303030),
                      fontWeight: FontWeight.w500,
                      fontSize: isSmallScreen ? 16 : 18,
                    ),
                  ),
                ),
                const Expanded(
                  child: Divider(thickness: 1, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF2A2F8C),
                      width: 2,
                    ),
                  ),
                  elevation: 4,
                ),
                onPressed: () { _reenviarCodigo();
                },
                child: Text(
                  'enviar novamente',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    color: const Color(0xFF2A2F8C),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
