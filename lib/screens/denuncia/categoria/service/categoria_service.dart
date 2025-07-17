import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class CategoriaService {
  static Future<List<dynamic>> buscarCategoriasComTipos() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['URL_API']}/denuncias/categorias/tipos'),
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        return json.decode(decodedBody);
      } else {
        print('Erro ao carregar categorias: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro na requisição: $e');
      return [];
    }
  }
}
