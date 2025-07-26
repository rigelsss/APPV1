/// CONFIRMAR_CADASTRO_SERVICE
///
/// Responsável por: Integração com API para confirmação de cadastro via código de verificação
/// e reenvio de códigos quando necessário.
/// Utilizado em: Tela de confirmação de cadastro para ativar contas de usuário.

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ConfirmarCadastroService {
  final _baseUrl = dotenv.env['URL_API'] ?? ''; // URL base da API SUDEMA

  /// CONFIRMARCODIGO
  ///
  /// Descrição: Confirma código de 6 dígitos enviado por e-mail para ativar conta.
  /// Parâmetros:
  /// - email: E-mail do usuário que está confirmando
  /// - token: Código de 6 dígitos recebido por e-mail
  /// Retorno: Future<String?> - null se sucesso, mensagem de erro se falhar
  Future<String?> confirmarCodigo({
    required String email,
    required String token,
  }) async {
    // Configura endpoint de confirmação
    final url = Uri.parse('$_baseUrl/auth/register/confirm');

    try {
      /// Integração com a API de confirmação
      ///
      /// Envia dados para o endpoint:
      /// POST /auth/register/confirm
      ///
      /// Requer e-mail, token e userType.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,           // E-mail do usuário
          "userType": "MOBILE",    // Tipo de usuário (app mobile)
          "token": token,          // Código de 6 dígitos
        }),
      );

      // Processamento da resposta da API
      if (response.statusCode == 200) {
        return null; // Sucesso: conta ativada
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        // Código inválido, expirado ou usuário não encontrado
        return 'Código inválido.';
      } else if (response.statusCode == 500) {
        // Erro interno do servidor
        return 'Erro interno do servidor. Tente novamente mais tarde.';
      } else {
        // Outros códigos de erro não mapeados
        return 'Erro desconhecido. Código: ${response.statusCode}';
      }
    } catch (e) {
      // Tratamento de erros de conexão/rede
      return 'Erro de conexão. Verifique sua internet.';
    }
  }

  /// REENVIARCODIGO
  ///
  /// Descrição: Solicita reenvio de código de confirmação para o e-mail do usuário.
  /// Parâmetros:
  /// - email: E-mail do usuário que precisa receber novo código
  /// Retorno: Future<String?> - null se sucesso, mensagem de erro se falhar
  ///
  /// Usado quando usuário não recebe o código inicial ou ele expira (2 horas).
  Future<String?> reenviarCodigo({required String email}) async {
    // Configura endpoint de reenvio
    final url = Uri.parse('$_baseUrl/auth/register/resend-confirm');

    try {
      /// Integração com a API de reenvio
      ///
      /// Envia solicitação para o endpoint:
      /// POST /auth/register/resend-confirm
      ///
      /// Requer apenas e-mail e userType.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,        // E-mail do usuário
          "userType": "MOBILE", // Tipo de usuário (app mobile)
        }),
      );

      // Processamento da resposta da API
      if (response.statusCode == 204) {
        return null; // Sucesso: código reenviado (No Content)
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        // Erro de validação ou usuário não encontrado
        // Tenta extrair mensagem específica da API
        return _extrairMensagemErro(response) ?? 'Erro ao reenviar o código.';
      } else if (response.statusCode == 500) {
        // Erro interno do servidor
        return 'Erro interno do servidor. Tente novamente mais tarde.';
      } else {
        // Outros códigos de erro não mapeados
        return 'Erro desconhecido. Código: ${response.statusCode}';
      }
    } catch (e) {
      // Tratamento de erros de conexão/rede
      return 'Erro de conexão. Verifique sua internet.';
    }
  }

  /// _EXTRAIRMENSAGEMERRO (Método privado)
  ///
  /// Descrição: Extrai mensagem de erro específica da resposta da API.
  /// Parâmetros:
  /// - response: Resposta HTTP da API com erro
  /// Retorno: String? - mensagem extraída ou null se não conseguir
  ///
  /// Tenta diferentes formatos de resposta da API para obter mensagem clara.
  String? _extrairMensagemErro(http.Response response) {
    try {
      // Decodifica resposta UTF-8 para suportar acentos
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      
      // Formato 1: Resposta é uma string direta
      if (body is String) return body;
      
      // Formato 2: Objeto com campo 'message'
      if (body['message'] != null) return body['message'].toString();
      
      // Formato 3: Objeto com campo 'token' (erros de token)
      if (body['token'] != null) return body['token'].toString();
    } catch (_) {
      // Ignora erros de parsing - retorna null para usar mensagem padrão
    }
    return null; // Não conseguiu extrair mensagem específica
  }

  // Fim da classe ConfirmarCadastroService
  // Métodos disponíveis:
  // - confirmarCodigo(): Ativa conta com código de 6 dígitos
  // - reenviarCodigo(): Solicita novo código por e-mail
  // - _extrairMensagemErro(): Extrai mensagens específicas da API
}
