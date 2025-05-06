import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Identificacao extends StatefulWidget {
  final VoidCallback onProsseguir;

  const Identificacao({super.key, required this.onProsseguir});

  @override
  State<Identificacao> createState() => _IdentificacaoState();
}


class _IdentificacaoState extends State<Identificacao> {
  String username = 'Acessar';
  String email = '';
  bool isLoading = true;
  String? token;

  @override
  void initState() {
    super.initState();
    _carregarToken();
  }

  Future<void> _carregarToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    if (savedToken != null && savedToken.isNotEmpty) {
      setState(() {
        token = savedToken;
        DenunciaData().tokenUsuario = token;
      });

      _carregarInformacoesUsuario(savedToken);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _carregarInformacoesUsuario(String token) async {
    if (token.isNotEmpty) {
      try {
        final data = await AuthController.obterInformacoesUsuario(token);
        if (data != null && data['user'] != null) {
          setState(() {
            username = data['user']['name'] ?? 'Usuário';
            email = data['user']['email'] ?? '';
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Erro ao carregar informações do usuário: $e');
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool get isLoggedIn {
    if (token == null || token!.isEmpty) {
      return false;
    }
    try {
      return !JwtDecoder.isExpired(token!);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Identificação',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            isLoggedIn
                ? Container()
                : const Text(
              'É necessário acessar o sistema para realizar uma denúncia. Após o login, você pode escolher fazer uma denúncia de forma anônima.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Center(
              child: isLoggedIn
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Você acessou o sistema como ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: email,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: widget.onProsseguir,
                    label: const Text(
                      'Prosseguir com Identificação',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2A2F8C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 128),
                    ),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: widget.onProsseguir,
                    label: const Text(
                      'Prosseguir Anônimo',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Color(0xFF2A2F8C),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 128),
                    ),
                  ),

                ],
              )
                  : ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                label: const Text(
                  'Acessar Sistema',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A2F8C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 128),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
