/// AUTH_ME
///
/// Responsável por: Gerenciamento de autenticação JWT com persistência local,
/// validação de expiração e obtenção de dados do usuário.
/// Utilizado em: Todo o app para controle de sessão e autenticação.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Classe AuthController
///
/// Descrição: Controller estático para gerenciamento completo de autenticação
/// com JWT, persistência local e integração com API.
class AuthController {
  static const String _tokenKey = 'token';  // Chave para SharedPreferences

  /// ISLOGGEDIN
  ///
  /// Descrição: Verifica se usuário está logado com token válido e não expirado.
  /// Parâmetros: nenhum
  /// Retorno: Future<bool> - true se logado, false se não
  ///
  /// Validação: token existe + não expirado via JWT decoder
  static Future<bool> isLoggedIn() async {
    final token = await getToken();  // Obtém token salvo
    if (token == null) return false; // Sem token = não logado
    return !JwtDecoder.isExpired(token);  // Verifica expiração
  }

  /// SAVETOKEN
  ///
  /// Descrição: Salva token JWT no SharedPreferences para persistência.
  /// Parâmetros:
  /// - token: Token JWT a ser salvo
  /// Retorno: Future<void>
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);  // Salva com chave fixa
  }

  /// UPDATETOKEN
  ///
  /// Descrição: Atualiza token existente (usado após alteração de e-mail).
  /// Parâmetros:
  /// - novoToken: Novo token JWT
  /// Retorno: Future<void>
  ///
  /// Wrapper para saveToken com semântica de atualização.
  static Future<void> updateToken(String novoToken) async {
    await saveToken(novoToken);  // Reutiliza método de salvar
  }

  /// LOGOUT
  ///
  /// Descrição: Remove token do SharedPreferences (logout local).
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);  // Remove token salvo
  }

  /// GETTOKEN
  ///
  /// Descrição: Recupera token salvo do SharedPreferences.
  /// Parâmetros: nenhum
  /// Retorno: Future<String?> - token ou null se não existe
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);  // Retorna token ou null
  }

  /// LIMPARTOKEN
  ///
  /// Descrição: Limpa token do SharedPreferences (alias para logout).
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Método duplicado - mesmo comportamento que logout().
  static Future<void> limparToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);  // Remove token salvo
  }

  /// OBTERINFORMACOESUSUARIO
  ///
  /// Descrição: Busca dados completos do usuário via API usando token JWT.
  /// Parâmetros:
  /// - token: Token JWT para autenticação
  /// Retorno: Future<Map<String, dynamic>?> - dados do usuário ou null
  ///
  /// Endpoint: GET /auth/me
  /// Resposta esperada: { "user": { dados_do_usuario } }
  static Future<Map<String, dynamic>?> obterInformacoesUsuario(String token) async {
    try {
      /// Integração com API SUDEMA
      ///
      /// Endpoint: GET /auth/me
      /// Header: Authorization: Bearer {token}
      /// Resposta: JSON com dados do usuário logado
      final response = await http.get(
        Uri.parse('${dotenv.env['URL_API']}/auth/me'),
        headers: {'Authorization': 'Bearer $token'},  // Autenticação JWT
      );

      // Processamento da resposta
      if (response.statusCode == 200) {
        // Decodificação UTF-8 para caracteres especiais
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);
        
        // Verifica estrutura esperada da resposta
        if (data['user'] != null) {
          print('✅ Dados recebidos do /auth/me: ${data['user']}');
          return data['user'];  // Retorna apenas dados do usuário
        } else {
          print('❗Campo "user" não encontrado na resposta.');
          return null;  // Estrutura inesperada
        }
      } else {
        // Erro HTTP: token inválido, expirado ou erro do servidor
        print('❌ Erro ${response.statusCode} ao buscar /auth/me: ${response.body}');
        return null;
      }
    } catch (e) {
      // Erro de conexão ou parsing
      print('❌ Exceção ao buscar dados do usuário: $e');
      return null;
    }
  }

  // Fim da classe AuthController
  // 
  // Controller de autenticação com:
  // 
  // 🔐 GERENCIAMENTO DE TOKEN:
  // - Persistência via SharedPreferences
  // - Validação de expiração JWT
  // - Métodos para salvar/atualizar/remover
  // - Verificação de login ativo
  // 
  // 👤 DADOS DO USUÁRIO:
  // - Integração com endpoint /auth/me
  // - Decodificação UTF-8 para acentos
  // - Tratamento de erros robusto
  // - Logs para debug
  // 
  // 🔄 MÉTODOS UTILITÁRIOS:
  // - isLoggedIn(): Verifica sessão ativa
  // - logout(): Limpeza local
  // - updateToken(): Atualização pós-alterações
  // - Consistência entre métodos
}
