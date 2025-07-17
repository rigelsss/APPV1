import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NoticiaController {
  Map<String, dynamic>? noticia;
  bool carregando = true;
  String? erro;
  final http.Client client;

  NoticiaController({http.Client? client}) : client = client ?? http.Client();

  Future<void> carregarNoticia(dynamic id) async {
    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      erro = '❌ URL da API não configurada.';
      carregando = false;
      return;
    }

    final url = Uri.parse('$baseUrl/noticias/$id');
    try {
      final resposta = await client.get(url);

      if (resposta.statusCode == 200) {
        final decoded = utf8.decode(resposta.bodyBytes);
        noticia = json.decode(decoded);
        carregando = false;
      } else {
        erro = '⚠️ Erro ${resposta.statusCode}: ${resposta.body}';
        carregando = false;
      }
    } catch (e) {
      erro = '💥 Falha ao carregar a notícia.';
      carregando = false;
    }
  }
}
