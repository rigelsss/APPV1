/// CATEGORIA_SERVICE
///
/// Responsável por: Integração com a API para buscar categorias e tipos de denúncias ambientais.
/// Utilizado em: Carregamento das opções de categorias na etapa 2 do fluxo de denúncias.
/// 
/// Este service conecta com a API da SUDEMA para obter:
/// - Categorias principais de infrações ambientais
/// - Subcategorias/tipos específicos para cada categoria
/// - Estrutura hierárquica para seleção do usuário

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class CategoriaService {
  /// Integração com a API de categorias de denúncias
  ///
  /// Busca categorias e subcategorias do endpoint:
  /// GET /denuncias/categorias/tipos
  ///
  /// Retorna estrutura hierárquica com categorias e seus tipos.
  static Future<List<dynamic>> buscarCategoriasComTipos() async {
    try {
      // Requisição para API da SUDEMA
      final response = await http.get(
        Uri.parse('${dotenv.env['URL_API']}/denuncias/categorias/tipos'),
      );

      if (response.statusCode == 200) {
        // Decodifica resposta UTF-8 para suportar acentos
        final decodedBody = utf8.decode(response.bodyBytes);
        return json.decode(decodedBody);
      } else {
        print('Erro ao carregar categorias: ${response.statusCode}');
        return []; // Retorna lista vazia em caso de erro
      }
    } catch (e) {
      // Trata erros de conexão ou parsing
      print('Erro na requisição: $e');
      return [];
    }
  }
}
