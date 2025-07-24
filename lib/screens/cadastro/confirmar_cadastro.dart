import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sudema_app/screens/login/login.dart';
import 'package:sudema_app/screens/cadastro/service/confirmar_cadastro_service.dart';
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
  final _service = ConfirmarCadastroService();

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
        color: const Color(0xFFAC5A5A),
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

  Future<void> _confirmarCodigo() async {
    if (_token.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o código de 6 dígitos.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final resultado = await _service.confirmarCodigo(
      email: widget.email,
      token: _token,
    );

    setState(() => _isLoading = false);

    if (resultado == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      _mostrarErroFlushbar(resultado);
    }
  }

  Future<void> _reenviarCodigo() async {
    setState(() => _isLoading = true);

    final resultado = await _service.reenviarCodigo(email: widget.email);

    setState(() => _isLoading = false);

    if (resultado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código reenviado com sucesso! Verifique seu e-mail.')),
      );
    } else {
      _mostrarErroFlushbar(resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

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
          horizontal: isSmallScreen ? 16 : size.width * 0.1,
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
              onChanged: (value) => setState(() => _token = value),
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
                onPressed: _isLoading ? null : _confirmarCodigo,
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
                const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
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
                const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
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
                    side: const BorderSide(color: Color(0xFF2A2F8C), width: 2),
                  ),
                  elevation: 4,
                ),
                onPressed: _isLoading ? null : _reenviarCodigo,
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
