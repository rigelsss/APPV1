// auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Método para registrar usuário
  Future<bool> registerUser(String name, String cpf, String email, String phone, String password) async {
    final url = Uri.parse('http://10.0.2.2:9000/auth/register'); // URL para emulador Android

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'cpf': cpf,
          'email': email,
          'phone': phone,
          'password': password,
          "userType": "MOBILE"
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Erro no cadastro: ${response.statusCode}');
        print('Resposta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return false;
    }
  }
}
