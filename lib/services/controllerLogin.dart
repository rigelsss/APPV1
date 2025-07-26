/// CONTROLLER_LOGIN
///
/// Responsável por: Controller de login com tratamento de diferentes estados
/// de usuário (ativo, não verificado, desabilitado) e persistência de token.
/// Utilizado em: Tela de login para autenticação de usuários.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'AuthMe.dart';

/// Classe LoginController
///
/// Descrição: Controller estático para processo de login com tratamento
/// completo de estados e persistência de sessão.
class LoginController {
  /// REALIZARLOGIN
  ///
  /// Descrição: Realiza login via API com tratamento de diferentes estados de usuário.
  /// Parâmetros:
  /// - email: E-mail do usuário
  /// - senha: Senha do usuário
  /// Retorno: Future<Map<String, dynamic>> com resultado estruturado
  ///
  /// Estados possíveis:
  /// - success: true (login ok)
  /// - nonVerifiedUser: true (usuário não verificado)
  /// - disabledUser: true (conta desativada)
  /// - message: string (erro genérico)
  static Future<Map<String, dynamic>> realizarLogin(String email, String senha) async {
    try {
      /// Integração com API SUDEMA
      ///
      /// Endpoint: POST /auth/login
      /// Payload:
      /// - login: E-mail do usuário
      /// - senha: Senha do usuário
      /// - userType: "MOBILE" (fixo para app)
      final response = await http.post(
        Uri.parse('${dotenv.env['URL_API']}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "login": email,        // E-mail como login
          "senha": senha,       // Senha fornecida
          "userType": "MOBILE", // Tipo fixo para app mobile
        }),
      );

      // Parse da resposta JSON
      final responseData = jsonDecode(response.body);

      // Processamento baseado no status code
      if (response.statusCode == 200) {
        // Sucesso: usuário autenticado
        final token = responseData['token'];
        if (token != null) {
          await AuthController.limparToken();  // Limpa token anterior
          await _salvarToken(token);           // Salva novo token
        }
        return {
          'success': true,      // Login bem-sucedido
          'data': responseData  // Dados completos da resposta
        };
      } else if (response.statusCode == 423 &&
                 responseData['errorCode'] == 'NON_VERIFIED_USER') {
        // Erro 423: Usuário não verificou e-mail
        return {
          'success': false,
          'nonVerifiedUser': true,  // Flag específica
          'email': email,           // E-mail para reenvio de código
        };
      } else if (response.statusCode == 403 &&
                 responseData['errorCode'] == 'DISABLED_USER') {
        // Erro 403: Conta desativada pelo usuário
        return {
          'success': false,
          'disabledUser': true  // Flag para tela de reativação
        };
      } else {
        // Outros erros: credenciais inválidas, servidor, etc.
        return {
          'success': false,
          // Usa mensagem da API ou fallback genérico
          'message': responseData['message'].toString().isNotEmpty == true 
          ? responseData['message']
          : 'E-mail ou senha inválidos.'
        };
      }
    } catch (e) {
      // Erro de conexão, timeout ou parsing
      print('Erro de conexão: $e');
      return {
        'success': false,
        'message': 'Erro de conexão'  // Mensagem genérica para usuário
      };
    }
  }
  
  /// _SALVARTOKEN
  ///
  /// Descrição: Método privado para salvar token no SharedPreferences.
  /// Parâmetros:
  /// - token: Token JWT recebido da API
  /// Retorno: Future<void>
  ///
  /// Nota: Método duplicado - AuthController.saveToken() faz o mesmo.
  static Future<void> _salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);  // Salva com chave fixa
  }

  // Fim da classe LoginController
  // 
  // Controller de login com:
  // 
  // 🔐 AUTENTICAÇÃO:
  // - Endpoint POST /auth/login
  // - Payload com email, senha e userType
  // - Persistência automática de token
  // - Limpeza de sessão anterior
  // 
  // 🚦 ESTADOS DE USUÁRIO:
  // - Status 200: Login bem-sucedido
  // - Status 423 + NON_VERIFIED_USER: E-mail não verificado
  // - Status 403 + DISABLED_USER: Conta desativada
  // - Outros: Credenciais inválidas ou erro servidor
  // 
  // 💬 RESPOSTA ESTRUTURADA:
  // - success: boolean (resultado principal)
  // - data: dados completos (se sucesso)
  // - nonVerifiedUser: flag específica
  // - disabledUser: flag específica
  // - message: mensagem de erro
  // - email: para reenvio de código
  // 
  // ⚙️ TRATAMENTO DE ERROS:
  // - Try-catch para conexão
  // - Mensagens da API ou fallback
  // - Logs para debug
  // - Estados específicos para UX
}
