import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginController {
  static Future<Map<String, dynamic>?> realizarLogin(
      String email,
      String senha,
      ) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:9000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "login": email,
          "password": senha,
          "userType": "MOBILE",
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Erro ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return null;
    }
  }
}
