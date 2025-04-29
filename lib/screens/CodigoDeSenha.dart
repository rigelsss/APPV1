import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sudema_app/screens/NovaSenha.dart';

class Codigodesenha extends StatefulWidget {
  const Codigodesenha({super.key});

  @override
  State<Codigodesenha> createState() => _CodigodesenhaState();
}

class _CodigodesenhaState extends State<Codigodesenha> {
  String _codigo = '';

  void _verificarCodigo() {
    if (_codigo.length == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Novasenha()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um código válido.')),
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
            Center(
              child: ElevatedButton(
                onPressed: _verificarCodigo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2F8C),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Verificar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
