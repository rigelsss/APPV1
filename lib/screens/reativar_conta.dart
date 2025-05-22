import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:sudema_app/services/AuthMe.dart';

class ReativarContaPage extends StatefulWidget {
  final String email;
  final String senha;

  const ReativarContaPage({super.key, required this.email, required this.senha});

  @override
  State<ReativarContaPage> createState() => _ReativarContaPageState();
}

class _ReativarContaPageState extends State<ReativarContaPage> {
  bool _isLoading = false;

  Future<void> _reativarConta() async {
    setState(() {
      _isLoading = true;
    });

    final baseUrl = dotenv.env['URL_API'];
    final url = Uri.parse('$baseUrl/usuarios/mobile/ativar');

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'senha': widget.senha,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        await AuthController.saveToken(data['token']);

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

        Flushbar(
          backgroundColor: const Color(0xFFD2FDE6),
          duration: const Duration(seconds: 4),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(12),
          margin: const EdgeInsets.all(8),
          messageText: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Conta reativada com sucesso!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B8C00),
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              )
            ],
          ),
        ).show(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao reativar conta')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro de conexão: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Reativar conta',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Essa conta foi desativada anteriormente.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Deseja reativá-la?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFAC5A5A),
                      side: const BorderSide(color: Color(0xFFAC5A5A)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _reativarConta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B8C00),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Reativar',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
