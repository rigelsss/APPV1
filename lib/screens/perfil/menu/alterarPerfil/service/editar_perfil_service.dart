/// EDITAR_PERFIL_SERVICE
///
/// Responsável por: Service para comunicação com API da SUDEMA para atualização
/// de dados do perfil do usuário via requisição PUT.
/// Utilizado em: EditarPerfilController para integração com backend.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Classe UsuarioService
///
/// Descrição: Service estático para operações de atualização de usuário via API SUDEMA.
class UsuarioService {
  /// ATUALIZARUSUARIO
  ///
  /// Descrição: Atualiza dados do usuário via API com autenticação JWT.
  /// Parâmetros:
  /// - id: ID do usuário na base de dados
  /// - token: Token JWT para autenticação
  /// - dados: Map com dados a serem atualizados (nome, telefone, cpf, userType)
  /// Retorno: Future<http.Response> - resposta completa da API
  ///
  /// Endpoint: PUT /usuarios/mobile/{id}
  static Future<http.Response> atualizarUsuario({
    required String id,
    required String token,
    required Map<String, dynamic> dados,
  }) async {
    // Obtém URL base da API do arquivo .env
    final baseUrl = dotenv.env['URL_API'];
    final url = Uri.parse('$baseUrl/usuarios/mobile/$id');

    /// Integração com API SUDEMA
    ///
    /// Envia requisição PUT para endpoint:
    /// PUT /usuarios/mobile/{id}
    ///
    /// Headers obrigatórios:
    /// - Authorization: Bearer {token}
    /// - Content-Type: application/json
    /// - Accept: application/json
    return await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',    // Autenticação JWT
        'Content-Type': 'application/json',  // Indica payload JSON
        'Accept': 'application/json',        // Espera resposta JSON
      },
      body: jsonEncode(dados),  // Serializa dados para JSON
    );
  }

  // Fim da classe UsuarioService
  // 
  // Service de atualização de perfil com:
  // - Autenticação via Bearer token
  // - Requisição PUT para API SUDEMA
  // - Payload dinâmico via Map
  // - URL dinâmica via variáveis de ambiente
  // - Headers completos para JSON
  // - Retorno de resposta completa para processamento
}
