/// DELETAR_CONTA
///
/// Responsável por: Tela de desativação de conta com confirmação por senha,
/// integração com API, feedback visual e navegação pós-desativação.
/// Utilizado em: Menu de perfil para permitir desativação segura da conta.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Widget DeletarContaPage
///
/// Descrição: Tela com aviso visual, campo de senha para confirmação,
/// botões de ação e feedback completo pós-desativação.
class DeletarContaPage extends StatefulWidget {
  const DeletarContaPage({super.key});

  @override
  State<DeletarContaPage> createState() => _DeletarContaPageState();
}

class _DeletarContaPageState extends State<DeletarContaPage> {
  final TextEditingController _senhaController = TextEditingController();  // Controller da senha
  bool _isLoading = false;   // Estado de carregamento durante desativação
  bool _obscureText = true;  // Estado de visibilidade da senha

  /// _DESATIVARONTA
  ///
  /// Descrição: Método principal para desativar conta com validação de segurança.
  /// Parâmetros: nenhum (usa _senhaController)
  /// Retorno: Future<void>
  ///
  /// Fluxo: loading → validação JWT → requisição API → feedback → navegação
  Future<void> _desativarConta() async {
    // Etapa 1: Ativa estado de carregamento
    setState(() => _isLoading = true);
    
    // Etapa 2: Validação de autenticação
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    String? userId;

    // Verifica existência e validade do token
    if (token != null && !JwtDecoder.isExpired(token)) {
      // Token válido: extrai ID do usuário
      final decodedToken = JwtDecoder.decode(token);
      userId = decodedToken['id'].toString();
    } else {
      // Token inválido: redireciona para login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Sessão expirada. Faça login novamente.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;  // Interrompe execução
    }

    // Etapa 3: Preparação da requisição para API
    final url = '${dotenv.env['URL_API']}/usuarios/mobile/$userId/desativar';

    /// Integração com API SUDEMA
    ///
    /// Endpoint: PATCH /usuarios/mobile/{id}/desativar
    /// Autenticação: Bearer Token (JWT)
    /// Payload: senha para confirmação de segurança
    ///
    /// A API valida:
    /// - Token JWT válido e não expirado
    /// - Senha fornecida corresponde à senha atual
    /// - Usuário existe e está ativo
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',       // Autenticação JWT
        'Content-Type': 'application/json',     // Indica payload JSON
      },
      body: jsonEncode({'senha': _senhaController.text}),  // Senha para confirmação
    );

    // Remove estado de carregamento
    setState(() => _isLoading = false);

    // Etapa 4: Processamento da resposta
    if (response.statusCode == 204) {
      // Sucesso: Status 204 (No Content) indica desativação bem-sucedida
      
      // Remove token local (logout automático)
      await prefs.remove('token');

      // Navega para home limpando stack de navegação
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/home',
        (route) => false,  // Remove todas as rotas anteriores
        arguments: {'desativado': true},  // Argumento para indicar desativação
      );

      // Feedback visual após navegação (delay para garantir construção da tela)
      Future.delayed(const Duration(milliseconds: 500), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Flushbar de sucesso com informações sobre reativação
          Flushbar(
            backgroundColor: const Color(0xFFD2FDE6),    // Verde claro
            duration: const Duration(seconds: 4),
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.circular(12),
            margin: const EdgeInsets.all(8),
            messageText: Row(
              children: [
                // Ícone de sucesso
                const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      // Título da mensagem
                      Text(
                        'Conta desativada!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B8C00),     // Verde escuro
                        ),
                      ),
                      SizedBox(height: 4),
                      // Instruções para reativação
                      Text(
                        'Para reativar, basta realizar login novamente.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1B8C00),     // Verde escuro
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ).show(context);
        });
      });
    } else {
      // Erro: Status diferente de 204 (geralmente 400 ou 401)
      /// 
      /// Possíveis erros:
      /// - Status 400: Senha incorreta
      /// - Status 401: Token inválido ou expirado
      /// - Status 404: Usuário não encontrado
      /// - Status 500: Erro interno do servidor
      Flushbar(
        title: 'Senha incorreta',
        message: 'Não foi possível desativar a conta. Verifique sua senha e tente novamente.',
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.red.shade600,         // Fundo vermelho
        icon: const Icon(Icons.error_outline, color: Colors.white),  // Ícone de erro
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(8),
      ).show(context);
    }
  }

  /// BUILD
  ///
  /// Descrição: Constrói tela com aviso visual, campo de senha e botões de ação.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Scaffold com estrutura completa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar com botão de voltar e título
      appBar: AppBar(
        titleSpacing: 0,           // Remove espaçamento extra
        elevation: 0,              // Remove sombra
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),  // Volta para tela anterior
        ),
        title: Text(
          'Deletar conta',
            style: GoogleFonts.lato(color: Colors.black, fontSize: 22),
        ),
      ),
      // Body scrollável com conteúdo centralizado
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),  // Padding uniforme
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Imagem de aviso visual
              Image.asset(
                'assets/images/warning.jpg',
                height: 120,  // Altura fixa para consistência
              ),
              const SizedBox(height: 24),
              // Pergunta de confirmação
               Align(
                alignment: Alignment.centerLeft,  // Alinha à esquerda
                child: Text(
                  'Tem certeza que deseja desativar sua conta do sistema?',
                  maxLines: 1,                     // Limita a 1 linha
                  overflow: TextOverflow.ellipsis, // Adiciona ... se necessário
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.black
                  ),
                ),
              ),
              const SizedBox(height: 40),  // Espaçamento maior
              // Instrução para inserir senha
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Para prosseguir, insira a sua senha',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              // Campo de senha com toggle de visibilidade
              TextField(
                controller: _senhaController,  // Controller da senha
                obscureText: _obscureText,     // Controla visibilidade
                decoration: InputDecoration(
                  hintText: 'Senha',
                  // Borda quando habilitado
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.grey[500]!,
                    ),
                  ),
                  // Borda quando focado
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 1.5,
                      color: Colors.grey[500]!,  // Mesma cor (sem destaque)
                    ),
                  ),
                  // Ícone de toggle de visibilidade
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;  // Alterna visibilidade
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),  // Espaçamento antes dos botões
              
              // Botão de confirmar desativação
              SizedBox(
                width: double.infinity,  // Largura total
                height: 56,              // Altura fixa
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _desativarConta,  // Desabilita se carregando
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],           // Fundo cinza claro
                    side: const BorderSide(color: Color(0xFF3C9C25), width: 1.5),  // Borda verde
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),   // Bordas bem arredondadas
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Color(0xFF3C9C25),  // Texto verde
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Botão de cancelar
              SizedBox(
                width: double.infinity,  // Largura total
                height: 56,              // Altura fixa
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),  // Volta se não carregando
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],           // Fundo cinza claro
                    side: const BorderSide(color: Color(0xFFAC5A5A), width: 1.5),  // Borda vermelha
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),   // Bordas bem arredondadas
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Color(0xFFAC5A5A),  // Texto vermelho
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fim da classe DeletarContaPage
  // 
  // Tela de desativação de conta com:
  // 
  // 🔒 SEGURANÇA:
  // - Confirmação por senha obrigatória
  // - Validação de token JWT com expiração
  // - Requisição PATCH para endpoint específico
  // - Logout automático após desativação
  // 
  // 🎨 INTERFACE:
  // - Imagem de aviso visual (warning.jpg)
  // - Pergunta de confirmação clara
  // - Campo de senha com toggle de visibilidade
  // - Botões com cores semânticas (verde/vermelho)
  // - Layout responsivo e centralizado
  // 
  // 📱 UX/UI:
  // - Estado de loading durante processo
  // - Feedback visual via Flushbar
  // - Mensagem de sucesso com instruções
  // - Tratamento de erros com mensagens claras
  // - Desabilitação de botões durante carregamento
  // 
  // 🌐 INTEGRAÇÃO API:
  // - Endpoint PATCH /usuarios/mobile/{id}/desativar
  // - Autenticação via Bearer token
  // - Payload com senha para confirmação
  // - Status 204 indica sucesso
  // - Tratamento de diferentes códigos de erro
  // 
  // 🗺️ NAVEGAÇÃO:
  // - Limpeza completa do stack após desativação
  // - Redirecionamento para home
  // - Argumento 'desativado' para contexto
  // - Delay para garantir construção da tela
  // - Feedback pós-navegação via PostFrameCallback
}
