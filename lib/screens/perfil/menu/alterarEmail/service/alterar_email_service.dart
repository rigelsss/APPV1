/// ALTERAR_EMAIL_SERVICE
///
/// Responsável por: Service para comunicação com API da SUDEMA para alteração de e-mail,
/// incluindo autenticação JWT, requisição HTTP e injeção de dependência para testes.
/// Utilizado em: AlterarEmailController para integração com backend.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Classe UsuarioService
///
/// Descrição: Service estático para operações de usuário via API SUDEMA
/// com suporte a injeção de cliente HTTP para testes.
class UsuarioService {
  /// ALTERAREMAIL
  ///
  /// Descrição: Altera e-mail do usuário via API com autenticação JWT.
  /// Parâmetros:
  /// - token: Token JWT para autenticação
  /// - id: ID do usuário na base de dados
  /// - senhaAtual: Senha atual para validação
  /// - novoEmail: Novo e-mail desejado
  /// - confirmacaoEmail: Confirmação do novo e-mail
  /// - client: Cliente HTTP opcional (para testes)
  /// Retorno: Future<http.Response> - resposta completa da API
  static Future<http.Response> alterarEmail({
    required String token,
    required String id,
    required String senhaAtual,
    required String novoEmail,
    required String confirmacaoEmail,
    http.Client? client,  // Injeção de dependência para testes
  }) async {
    // Obtém URL base da API do arquivo .env
    final baseUrl = dotenv.env['URL_API'];
    final url = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');
    
    // Usa cliente fornecido ou cria novo (padrão para produção)
    client ??= http.Client();

    /// Integração com API SUDEMA
    ///
    /// Envia requisição PUT para endpoint:
    /// PUT /usuarios/mobile/{id}/alterar-email
    ///
    /// Requer autenticação Bearer e payload com senha e e-mails.
    return await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // Autenticação JWT
      },
      body: jsonEncode({
        "senhaAtual": senhaAtual,           // Senha para validação
        "novoEmail": novoEmail,             // Novo e-mail
        "confirmacaoEmail": confirmacaoEmail,  // Confirmação (deve coincidir)
      }),
    );
  }

  // Fim da classe UsuarioService
  // 
  // Service de alteração de e-mail com:
  // - Autenticação via Bearer token
  // - Requisição PUT para API SUDEMA
  // - Payload com senha e e-mails
  // - URL dinâmica via variáveis de ambiente
  // - Injeção de dependência para testabilidade
  // - Retorno de resposta completa para processamento no controller
}
