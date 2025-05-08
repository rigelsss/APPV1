import 'package:flutter/material.dart';
import 'package:sudema_app/controllers/identificacao_controller.dart';
import 'package:sudema_app/screens/widgets/identificacao_buttons.dart';

class Identificacao extends StatefulWidget {
  final VoidCallback onProsseguir;

  const Identificacao({super.key, required this.onProsseguir});

  @override
  State<Identificacao> createState() => _IdentificacaoState();
}

class _IdentificacaoState extends State<Identificacao> {
  final controller = IdentificacaoController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller.carregarDadosUsuario().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = controller.isTokenValido;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Identificação',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (!isLoggedIn)
                    const Text(
                      'É necessário acessar o sistema para realizar uma denúncia. Após o login, você pode escolher fazer uma denúncia de forma anônima.',
                      style: TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 24),
                  Center(
                    child: IdentificacaoButtons(
                      isLoggedIn: isLoggedIn,
                      email: controller.email,
                      onProsseguir: widget.onProsseguir,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
