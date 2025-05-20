import 'package:flutter/material.dart';
import 'package:sudema_app/controllers/identificacao_controller.dart';
import 'package:sudema_app/screens/widgets/identificacao_buttons.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/services/AuthMe.dart';

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
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await controller.carregarDadosUsuario();

    final dados = DenunciaData();

    // Verificação adicional caso os dados não tenham sido preenchidos corretamente
    if (dados.usuarioId == null || dados.tokenUsuario == null) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        final info = await AuthController.obterInformacoesUsuario(token);
        if (info != null) {
          dados.usuarioId = info['id'];
          dados.tokenUsuario = token;
          print('✅ Dados reforçados manualmente: ${dados.usuarioId}, ${dados.tokenUsuario}');
        }
      }
    }

    setState(() {
      isLoading = false;
    });

    print('📌 Usuário carregado: ${dados.usuarioId}, Token: ${dados.tokenUsuario}');
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
