import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sudema_app/screens/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class codigoRegistro extends StatefulWidget {
  const codigoRegistro({super.key});

  @override
  State<codigoRegistro> createState() => _codigoRegistroState();
}

class _codigoRegistroState extends State<codigoRegistro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Conta'),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2F8C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  // lógica do botão Verificar
                },
                child: const Text(
                  'Verificar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Não recebeu o código?',
                    style: TextStyle(
                      color: Color(0xFF303030),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
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
                onPressed: () {
                  // lógica do botão Enviar novamente
                },
                child: const Text(
                  'enviar novamente',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2A2F8C),
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
