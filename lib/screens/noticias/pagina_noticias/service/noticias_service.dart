import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NoticiasService {
  static Future<List<dynamic>> carregarNoticias() async {
    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('❌ URL da API não configurada.');
    }

    final url = Uri.parse('$baseUrl/noticias/top30-com-tags');
    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final decoded = utf8.decode(resposta.bodyBytes);
      return json.decode(decoded);
    } else {
      throw Exception('⚠️ Erro ${resposta.statusCode}: ${resposta.body}');
    }
  }
}
