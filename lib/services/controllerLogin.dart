import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginController {
  static Future<Map<String, dynamic>?> realizarLogin(String email, String senha) async {
    try {
      final response = await http.post(
      Uri.parse('${dotenv.env['URL_API']}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "login": email,
          "password": senha,
          "userType": "MOBILE",
        }),
      );

      if (response.statusCode == 200) {
        // Decodificar a resposta e salvar o token
        final responseData = jsonDecode(response.body);
        final token = responseData['token']; // Verifique se a chave 'token' está correta.

        // Salvar o token
        if (token != null) {
          await _salvarToken(token);
        }

        return responseData;
      } else {
        print('Erro ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return null;
    }
  }

  // Função para salvar o token
  static Future<void> _salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}
