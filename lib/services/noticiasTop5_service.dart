import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';


class CarregarNoticias {
  Future<List<Noticia>> buscarNoticias() async {
    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('URL da API não configurada.');
    }

    final url = Uri.parse('$baseUrl/noticias/top5');

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final decodedBody = utf8.decode(resposta.bodyBytes);
      final List<dynamic> listaNoticias = json.decode(decodedBody);

      return listaNoticias.map((json) {
        return Noticia(
          id: json['id'].toString(),
          titulo: _extrairTextoHtml(json['titulo']),
          resumo: _extrairTextoHtml(json['resumo']),
          imagemUrl: json['imagem_url'],
          dataHoraPublicacao: DateFormat("dd/MM/yyyy HH'h'mm").parse(json['data_publicacao_formatada']),
        );
      }).toList();
    } else {
      throw Exception('Erro ao carregar notícias: ${resposta.statusCode}');
    }
  }

  String _extrairTextoHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }
}
