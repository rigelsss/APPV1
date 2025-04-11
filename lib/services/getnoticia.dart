import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';

class CarregarNoticias {
  final String apiKey = 'bd1bc4b15ed94607b34979adec47fd77';

  Future<List<Noticia>> buscarNoticias() async {
  final url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey');

  final resposta = await http.get(url);

  if (resposta.statusCode == 200) {
    print('Resposta completa da API: ${resposta.body}');  // Imprimir o corpo da resposta
    final dados = json.decode(resposta.body);
    final List listaArtigos = dados['articles'];

    return listaArtigos.map((json) => Noticia.fromJson(json)).toList();
  } else {
    throw Exception('Erro ao carregar notícias');
  }
}

}
