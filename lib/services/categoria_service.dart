// lib/services/categoria_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoriaService {
  static Future<List<dynamic>> buscarCategorias() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/categorias'));
      if (response.statusCode == 200) {
        final List<dynamic> categorias = json.decode(response.body);
        return categorias;
      } else {
        throw Exception('Erro ao carregar categorias: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar categorias: $e');
      rethrow; // repassa o erro para quem chamou
    }
  }
}
