import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/login.dart';
import 'package:sudema_app/screens/widgets/appbardenuncia.dart';

class Novasenha extends StatefulWidget {
  final String email;
  final String token;

  const Novasenha({super.key, required this.email, required this.token});

  @override
  State<Novasenha> createState() => _NovasenhaState();
}

class _NovasenhaState extends State<Novasenha> {
  final _novaSenhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _obscureNovaSenha = true;
  bool _obscureConfirmarSenha = true;
  bool _isLoading = false;

  Future<void> _resetarSenha() async {
    final novaSenha = _novaSenhaController.text.trim();
    final confirmarSenha = _confirmarSenhaController.text.trim();

    if (novaSenha.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A senha deve ter no mínimo 8 caracteres.'), backgroundColor: Colors.red),
      );
      return;
    }

    if (novaSenha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${dotenv.env['URL_API']}/password-reset/reset-password');
    debugPrint('🔐 Enviando solicitação para redefinir senha...');
    debugPrint('📧 Email: ${widget.email}');
    debugPrint('🔑 Token: ${widget.token}');
    debugPrint('🔒 Nova senha: $novaSenha');
    debugPrint('🌐 URL: $url');


    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'userType': 'MOBILE',
          'token': widget.token,
          'novaSenha': novaSenha,
        }),
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha redefinida com sucesso!'), backgroundColor: Colors.green),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
        );
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Erro ao redefinir a senha.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
        debugPrint('❗ Status inesperado: ${response.statusCode}');
        debugPrint('❗ Corpo da resposta: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão. Tente novamente.'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarDenuncia(title: 'Crie uma nova senha'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Crie uma senha forte com, no mínimo, oito caracteres, contendo uma combinação de letras, números e símbolos.',
              style: GoogleFonts.lato(fontSize: 16,),
            ),
            const SizedBox(height: 20),
            const Text('Nova senha', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _novaSenhaController,
              obscureText: _obscureNovaSenha,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNovaSenha ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureNovaSenha = !_obscureNovaSenha;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Confirmar a nova senha', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _confirmarSenhaController,
              obscureText: _obscureConfirmarSenha,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmarSenha ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmarSenha = !_obscureConfirmarSenha;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _resetarSenha,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF11B8C00),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Redefinir',
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
