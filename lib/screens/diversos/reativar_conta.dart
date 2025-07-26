/// REATIVAR_CONTA
///
/// Responsável por: Gerenciar a reativação de contas de usuários que foram desativadas anteriormente.
/// Utilizado em: Fluxo de login quando o sistema detecta uma conta desativada.
/// 
/// Esta tela permite que usuários com contas desativadas possam reativá-las
/// usando suas credenciais originais (email e senha). Após a reativação,
/// o usuário é automaticamente logado e redirecionado para a tela principal.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:sudema_app/services/AuthMe.dart';

class ReativarContaPage extends StatefulWidget {
  final String email;    // Email da conta a ser reativada
  final String senha;    // Senha da conta a ser reativada

  const ReativarContaPage({super.key, required this.email, required this.senha});

  @override
  State<ReativarContaPage> createState() => _ReativarContaPageState();
}

class _ReativarContaPageState extends State<ReativarContaPage> {
  // Controla o estado de carregamento durante a requisição de reativação
  bool _isLoading = false;

  /// _reativarConta
  ///
  /// Descrição: Executa o processo completo de reativação da conta do usuário.
  /// Parâmetros: nenhum (usa email e senha do widget)
  /// Retorno: Future<void>
  ///
  /// Realiza a chamada à API, processa a resposta e redireciona o usuário
  /// para a tela principal em caso de sucesso.
  Future<void> _reativarConta() async {
    _setLoading(true);

    try {
      // Envia requisição para a API de reativação
      final response = await _enviarRequisicao();
      final data = jsonDecode(response.body);

      // Verifica se a reativação foi bem-sucedida
      if (response.statusCode == 200 && data['token'] != null) {
        await _processarRespostaComSucesso(data);
      } else {
        _mostrarErro(data['message'] ?? 'Erro ao reativar conta');
      }
    } catch (e) {
      // Trata erros de conexão ou outros erros inesperados
      _mostrarErro('Erro de conexão: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Integração com a API de reativação de contas
  ///
  /// Envia os dados de email e senha para o endpoint:
  /// PATCH /usuarios/mobile/ativar
  ///
  /// Retorna o token JWT em caso de sucesso.
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

  /// _processarRespostaComSucesso
  ///
  /// Descrição: Processa a resposta bem-sucedida da API e autentica o usuário.
  /// Parâmetros:
  /// - data: dados retornados pela API contendo o token
  /// Retorno: Future<void>
  ///
  /// Salva o token JWT e redireciona para a tela principal do app.
  Future<void> _processarRespostaComSucesso(Map<String, dynamic> data) async {
    // Salva o token JWT para autenticação nas próximas requisições
    await AuthController.saveToken(data['token']);

    if (!mounted) return;
    // Remove todas as telas anteriores e vai direto para a home
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

    _mostrarMensagemSucesso();
  }

  /// _mostrarMensagemSucesso
  ///
  /// Descrição: Exibe uma mensagem de sucesso personalizada após reativação.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Usa Flushbar para mostrar feedback visual positivo ao usuário.
  void _mostrarMensagemSucesso() {
    Flushbar(
      backgroundColor: const Color(0xFFD2FDE6), // Verde claro da SUDEMA
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
                    color: Color(0xFF1B8C00), // Verde da SUDEMA
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

  /// _mostrarErro
  ///
  /// Descrição: Exibe mensagens de erro durante o processo de reativação.
  /// Parâmetros:
  /// - mensagem: texto do erro a ser exibido
  /// Retorno: void
  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  /// _setLoading
  ///
  /// Descrição: Controla o estado de carregamento da interface.
  /// Parâmetros:
  /// - loading: true para mostrar loading, false para ocultar
  /// Retorno: void
  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  /// Widget ReativarContaPage
  ///
  /// Descrição: Interface principal para reativação de contas desativadas.
  /// Contém texto informativo e botões de ação (Cancelar/Reativar).
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  /// _buildAppBar
  ///
  /// Descrição: Constrói a barra superior com título e botão de voltar.
  /// Parâmetros: nenhum
  /// Retorno: PreferredSizeWidget - AppBar configurada
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.pop(context), // Volta para tela anterior
      ),
      title: const Text(
        'Reativar conta',
        style: TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      elevation: 0, // Remove sombra da AppBar
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  /// _buildBody
  ///
  /// Descrição: Constrói o conteúdo principal da tela de reativação.
  /// Parâmetros: nenhum
  /// Retorno: Widget - corpo da página com texto e botões
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

  /// _buildTextoInformativo
  ///
  /// Descrição: Constrói o texto explicativo sobre a conta desativada.
  /// Parâmetros: nenhum
  /// Retorno: Widget - textos informativos centralizados
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

  /// _buildBotoes
  ///
  /// Descrição: Constrói a linha de botões de ação (Cancelar e Reativar).
  /// Parâmetros: nenhum
  /// Retorno: Widget - linha com os dois botões
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

  /// _buildBotaoCancelar
  ///
  /// Descrição: Constrói o botão de cancelar a reativação.
  /// Parâmetros: nenhum
  /// Retorno: Widget - botão outlined vermelho
  Widget _buildBotaoCancelar() {
    return OutlinedButton(
      onPressed: () => Navigator.pop(context), // Volta para tela anterior
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFAC5A5A), // Vermelho para cancelar
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

  /// _buildBotaoReativar
  ///
  /// Descrição: Constrói o botão principal de reativação da conta.
  /// Parâmetros: nenhum
  /// Retorno: Widget - botão verde com loading quando necessário
  Widget _buildBotaoReativar() {
    return ElevatedButton(
      // Desabilita o botão durante o carregamento
      onPressed: _isLoading ? null : _reativarConta,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B8C00), // Verde da SUDEMA
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
