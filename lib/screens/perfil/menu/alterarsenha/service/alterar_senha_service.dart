/// ALTERAR_SENHA_SERVICE
///
/// Responsável por: Comunicação com API da SUDEMA para alteração de senha,
/// incluindo autenticação, requisição HTTP e tratamento de respostas.
/// Utilizado em: AlterarSenhaController para integração com backend.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Classe UsuarioController
///
/// Descrição: Service estático para operações de usuário via API SUDEMA.
class UsuarioController {
  /// ALTERARSENHA
  ///
  /// Descrição: Altera senha do usuário via API com autenticação JWT.
  /// Parâmetros:
  /// - userId: ID do usuário na base de dados
  /// - senhaAtual: Senha atual para validação
  /// - novaSenha: Nova senha desejada
  /// Retorno: Future<String?> - null se sucesso, mensagem de erro se falhar
  static Future<String?> alterarSenha({
    required String userId,
    required String senhaAtual,
    required String novaSenha,
  }) async {
    // Obtém token de autenticação salvo
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Valida existência do token
    if (token == null) return 'Token não encontrado';

    // Configura endpoint da API SUDEMA
    final url = 'https://homolog.sigma.pb.gov.br/sislia/api/v1/usuarios/mobile/$userId/alterar-senha';

    try {
      /// Integração com API SUDEMA
      ///
      /// Envia requisição PUT para endpoint:
      /// PUT /usuarios/mobile/{userId}/alterar-senha
      ///
      /// Requer autenticação Bearer e payload com senhas.
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',        // Autenticação JWT
        },
        body: jsonEncode({
          'senhaAtual': senhaAtual,                 // Senha atual para validação
          'novaSenha': novaSenha,                   // Nova senha
          'confirmacaoNovaSenha': novaSenha,        // Confirmação (mesmo valor)
        }),
      );

      // Logs para debug (remover em produção)
      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');

      // Processamento da resposta da API
      if (response.statusCode == 204) {
        // Sucesso: No Content (operação bem-sucedida sem conteúdo)
        print('Nenhum conteúdo para processar.');
        return null;
      }

      if (response.statusCode == 200) {
        // Sucesso: OK com conteúdo
        if (response.body.isNotEmpty) {
          print('Senha alterada com sucesso: ${response.body}');
          return null;
        } else {
          // Resposta 200 mas sem conteúdo (inesperado)
          print('Corpo da resposta vazio.');
          return 'Erro ao alterar a senha';
        }
      } else {
        // Erro: extrai mensagem da API ou usa genérica
        return jsonDecode(response.body)['message'] ?? 'Erro ao alterar a senha';
      }
    } catch (e) {
      // Tratamento de erros de conexão/rede
      print('Erro na requisição: $e');
      return 'Erro ao conectar com o servidor';
    }
  }

  // Fim da classe UsuarioController
  // 
  // Service de alteração de senha com:
  // - Autenticação via Bearer token
  // - Requisição PUT para API SUDEMA
  // - Payload com senha atual e nova
  // - Tratamento de códigos 200, 204 e erros
  // - Extração de mensagens de erro da API
  // - Logs para debug
}
