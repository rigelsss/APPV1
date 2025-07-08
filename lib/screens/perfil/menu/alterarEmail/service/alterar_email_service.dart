import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UsuarioService {
  static Future<http.Response> alterarEmail({
    required String token,
    required String id,
    required String senhaAtual,
    required String novoEmail,
    required String confirmacaoEmail,
  }) async {
    final baseUrl = dotenv.env['URL_API'];
    final url = Uri.parse('$baseUrl/usuarios/mobile/$id/alterar-email');

    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "senhaAtual": senhaAtual,
        "novoEmail": novoEmail,
        "confirmacaoEmail": confirmacaoEmail,
      }),
    );
  }
}
