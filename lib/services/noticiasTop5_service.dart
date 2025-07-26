/// NOTICIAS_TOP5_SERVICE
///
/// Responsável por: Serviço para buscar as 5 notícias mais recentes da SUDEMA
/// com tratamento de HTML e formatação de data brasileira.
/// Utilizado em: Home e sistema de notícias para exibir conteúdo atualizado.

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

/// Classe CarregarNoticias
///
/// Descrição: Serviço para integração com API de notícias da SUDEMA
/// com limpeza de HTML e parsing de data.
class CarregarNoticias {
  /// BUSCARNOTICIAS
  ///
  /// Descrição: Busca as 5 notícias mais recentes via API com tratamento completo.
  /// Parâmetros: nenhum
  /// Retorno: Future<List<Noticia>> - lista de notícias ou exception
  ///
  /// Endpoint: GET /noticias/top5
  /// Processa: HTML cleanup + data parsing + modelo Noticia
  Future<List<Noticia>> buscarNoticias() async {
    // Validação de configuração
    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('URL da API não configurada.');
    }

    final url = Uri.parse('$baseUrl/noticias/top5');

    /// Integração com API SUDEMA
    ///
    /// Endpoint: GET /noticias/top5
    /// Resposta: Array JSON com notícias mais recentes
    final resposta = await http.get(url);

    // Processamento da resposta
    if (resposta.statusCode == 200) {
      // Decodificação UTF-8 para caracteres especiais
      final decodedBody = utf8.decode(resposta.bodyBytes);
      final List<dynamic> listaNoticias = json.decode(decodedBody);

      // Mapeia cada item JSON para modelo Noticia
      return listaNoticias.map((json) {
        return Noticia(
          id: json['id'].toString(),                    // Converte ID para String
          titulo: _extrairTextoHtml(json['titulo']),    // Remove tags HTML do título
          resumo: _extrairTextoHtml(json['resumo']),    // Remove tags HTML do resumo
          imagemUrl: json['imagem_url'],                // URL da imagem (pode ser null)
          // Parse da data formatada brasileira
          dataHoraPublicacao: DateFormat("dd/MM/yyyy HH'h'mm").parse(
            json['data_publicacao_formatada']
          ),
        );
      }).toList();
    } else {
      // Erro HTTP: API indisponível, erro interno, etc.
      throw Exception('Erro ao carregar notícias: ${resposta.statusCode}');
    }
  }

  /// _EXTRAIRTEXTOHTML
  ///
  /// Descrição: Método privado para remover tags HTML e limpar texto.
  /// Parâmetros:
  /// - html: String com conteúdo HTML
  /// Retorno: String limpa sem tags HTML
  ///
  /// Regex: Remove tudo entre < e > (tags HTML)
  /// Trim: Remove espaços extras no início/fim
  String _extrairTextoHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  // Fim da classe CarregarNoticias
  // 
  // Serviço de notícias com:
  // 
  // 📰 INTEGRAÇÃO API:
  // - Endpoint GET /noticias/top5
  // - Decodificação UTF-8 para acentos
  // - Tratamento de status codes
  // - Exceptions para erros
  // 
  // 🎨 PROCESSAMENTO DE CONTEÚDO:
  // - Limpeza de tags HTML via regex
  // - Trim de espaços extras
  // - Conversão de ID para String
  // - Preservação de URLs de imagem
  // 
  // 📅 TRATAMENTO DE DATA:
  // - DateFormat brasileiro: dd/MM/yyyy HH'h'mm
  // - Parse de string para DateTime
  // - Formato da API: "15/03/2024 14h30"
  // - Integração com modelo Noticia
  // 
  // 🔄 MAPEAMENTO:
  // - Lista dinâmica → List<Noticia>
  // - Factory pattern via construtor
  // - Tratamento de campos opcionais
  // - Estrutura para carrossel e listagem
}
