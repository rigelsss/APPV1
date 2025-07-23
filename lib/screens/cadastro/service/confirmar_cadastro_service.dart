import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ConfirmarCadastroService {
  final _baseUrl = dotenv.env['URL_API'] ?? '';

  Future<String?> confirmarCodigo({
    required String email,
    required String token,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/register/confirm');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "userType": "MOBILE",
          "token": token,
        }),
      );

      if (response.statusCode == 200) {
        return null; // sucesso
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        return 'Código inválido.';
      } else if (response.statusCode == 500) {
        return 'Erro interno do servidor. Tente novamente mais tarde.';
      } else {
        return 'Erro desconhecido. Código: ${response.statusCode}';
      }
    } catch (e) {
      return 'Erro de conexão. Verifique sua internet.';
    }
  }

  Future<String?> reenviarCodigo({required String email}) async {
    final url = Uri.parse('$_baseUrl/auth/register/resend-confirm');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "userType": "MOBILE",
        }),
      );

      if (response.statusCode == 204) {
        return null; // sucesso
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        return _extrairMensagemErro(response) ?? 'Erro ao reenviar o código.';
      } else if (response.statusCode == 500) {
        return 'Erro interno do servidor. Tente novamente mais tarde.';
      } else {
        return 'Erro desconhecido. Código: ${response.statusCode}';
      }
    } catch (e) {
      return 'Erro de conexão. Verifique sua internet.';
    }
  }

  String? _extrairMensagemErro(http.Response response) {
    try {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is String) return body;
      if (body['message'] != null) return body['message'].toString();
      if (body['token'] != null) return body['token'].toString();
    } catch (_) {}
    return null;
  }
}
