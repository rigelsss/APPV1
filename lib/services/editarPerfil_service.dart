import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UsuarioService {
  static Future<http.Response> atualizarUsuario({
    required String id,
    required String token,
    required Map<String, dynamic> dados,
  }) async {
    final baseUrl = dotenv.env['URL_API'];
    final url = Uri.parse('$baseUrl/usuarios/mobile/$id');

    return await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(dados),
    );
  }
}
