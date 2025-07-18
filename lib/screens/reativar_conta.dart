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

  // Método para ativar a conta do usuário
  Future<void> _reativarConta() async {
    _setLoading(true);

    try {
      final response = await _enviarRequisicao();
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['token'] != null) {
        await _processarRespostaComSucesso(data);
      } else {
        _mostrarErro(data['message'] ?? 'Erro ao reativar conta');
      }
    } catch (e) {
      _mostrarErro('Erro de conexão: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Método para enviar a requisição HTTP
  Future<http.Response> _enviarRequisicao() async {
    final baseUrl = dotenv.env['URL_API'];
    final url = Uri.parse('$baseUrl/usuarios/mobile/ativar');

    return await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'senha': widget.senha,
      }),
    );
  }

  // Método para processar resposta bem-sucedida
  Future<void> _processarRespostaComSucesso(Map<String, dynamic> data) async {
    await AuthController.saveToken(data['token']);

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

    _mostrarMensagemSucesso();
  }

  // Método para mostrar mensagem de sucesso
  void _mostrarMensagemSucesso() {
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
  }

  // Método para mostrar mensagem de erro
  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  // Método para atualizar estado de carregamento
  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // Método para construir a AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Reativar conta',
        style: TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  // Método para construir o corpo da página
  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          _buildTextoInformativo(),
          const SizedBox(height: 48),
          _buildBotoes(),
        ],
      ),
    );
  }

  // Método para construir o texto informativo
  Widget _buildTextoInformativo() {
    return Column(
      children: const [
        Text(
          'Essa conta foi desativada anteriormente.',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Text(
          'Deseja reativá-la?',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Método para construir os botões
  Widget _buildBotoes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildBotaoCancelar(),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildBotaoReativar(),
        ),
      ],
    );
  }

  // Método para construir o botão de cancelar
  Widget _buildBotaoCancelar() {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFAC5A5A),
        side: const BorderSide(color: Color(0xFFAC5A5A), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text(
        'Cancelar',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  // Método para construir o botão de reativar
  Widget _buildBotaoReativar() {
    return ElevatedButton(
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
    );
  }
}
