import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';

class CarregarNoticias {
  final String apiKey = 'bd1bc4b15ed94607b34979adec47fd77';

  Future<List<Noticia>> buscarNoticias() async {
    final url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = json.decode(resposta.body);
      final List listaArtigos = dados['articles'];

      // Debug: Exibir as 3 primeiras matérias
      for (var i = 0; i < listaArtigos.length && i < 3; i++) {
        print('--- Notícia $i ---');
        print('Título: ${listaArtigos[i]['title']}');
        print('Descrição: ${listaArtigos[i]['description']}');
        print('Imagem: ${listaArtigos[i]['urlToImage']}');
        print('Publicado em: ${listaArtigos[i]['publishedAt']}');
        print('URL: ${listaArtigos[i]['url']}');
      }

      return listaArtigos.map((json) => Noticia.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar notícias');
    }
  }
}
