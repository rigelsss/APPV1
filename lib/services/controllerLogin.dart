import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'AuthMe.dart';

class LoginController {
  static Future<Map<String, dynamic>> realizarLogin(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['URL_API']}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "login": email,
          "senha": senha,
          "userType": "MOBILE",
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseData['token'];
        if (token != null) {
          await AuthController.limparToken();
          await _salvarToken(token);
        }
        return {
          'success': true, 
          'data': responseData
        };
      } else if (response.statusCode == 423 &&
                 responseData['errorCode'] == 'NON_VERIFIED_USER') {
        return {
          'success': false,
          'nonVerifiedUser': true,
          'email': email,
        };
      } else if (response.statusCode == 403 &&
                 responseData['errorCode'] == 'DISABLED_USER') {
        return {
          'success': false, 
          'disabledUser': true
        };
      } else {
        return {
          'success': false, 
          'message': responseData['message'].toString().isNotEmpty == true 
          ? responseData['message']
          : 'E-mail ou senha inválidos.'
        };
      }
    } catch (e) {
      print('Erro de conexão: $e');
      return {
        'success': false, 
        'message': 'Erro de conexão'
      };
    }
  }
  
  static Future<void> _salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}
