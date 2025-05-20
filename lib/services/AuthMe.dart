import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthController {
  static const String _tokenKey = 'token';

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;
    return !JwtDecoder.isExpired(token);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> updateToken(String novoToken) async {
    await saveToken(novoToken);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<Map<String, dynamic>?> obterInformacoesUsuario(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL_API']}/auth/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['user'] != null) {
          print('✅ Dados recebidos do /auth/me: ${data['user']}');
          return data['user'];
        } else {
          print('❗Campo "user" não encontrado na resposta.');
          return null;
        }
      } else {
        print('❌ Erro ${response.statusCode} ao buscar /auth/me: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Exceção ao buscar dados do usuário: $e');
      return null;
    }
  }
}
