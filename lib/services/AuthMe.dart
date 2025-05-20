import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthController {
  static Future<Map<String, dynamic>?> obterInformacoesUsuario(String token) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:9000/auth/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Erro ao buscar dados do usuário: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }
}
