import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoriaService {
  static Future<List<dynamic>> buscarCategoriasComTipos() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:9000/api/v1/denuncias/categorias/tipos'),
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
