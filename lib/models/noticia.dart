/// NOTICIA
///
/// Responsável por: Modelo de dados para notícias da SUDEMA com informações
/// ambientais, imagem e data de publicação formatada.
/// Utilizado em: Sistema de notícias para exibir conteúdo informativo.

import 'package:intl/intl.dart';

/// Classe Noticia
///
/// Descrição: Representa uma notícia com metadados completos incluindo
/// data formatada e URL de imagem.
class Noticia {
  final String id;                    // ID único da notícia
  final String titulo;                // Título da notícia
  final String resumo;                // Resumo/descrição
  final String imagemUrl;             // URL da imagem de capa
  final DateTime dataHoraPublicacao;  // Data e hora de publicação

  /// CONSTRUTOR
  ///
  /// Descrição: Cria instância de notícia com todos os campos obrigatórios.
  /// Parâmetros:
  /// - id: Identificador único
  /// - titulo: Título da notícia
  /// - resumo: Resumo do conteúdo
  /// - imagemUrl: URL da imagem
  /// - dataHoraPublicacao: DateTime da publicação
  Noticia({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.imagemUrl,
    required this.dataHoraPublicacao,
  });

  /// FROMJSON
  ///
  /// Descrição: Factory constructor para criar notícia a partir de JSON da API.
  /// Parâmetros:
  /// - json: Map com dados da API de notícias
  /// Retorno: Noticia configurada
  ///
  /// Mapeamento da API:
  /// - 'id' → id (convertido para String)
  /// - 'titulo' → titulo
  /// - 'resumo' → resumo
  /// - 'imagem_url' → imagemUrl
  /// - 'data_publicacao_formatada' → dataHoraPublicacao (parsed)
  ///
  /// Formato de data esperado: "dd/MM/yyyy HH'h'mm" (ex: "15/03/2024 14h30")
  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'].toString(),                     // Conversão para String
      titulo: json['titulo'],                        // Título direto
      resumo: json['resumo'],                        // Resumo direto
      imagemUrl: json['imagem_url'],                 // URL da imagem
      // Parse da data formatada da API usando DateFormat
      dataHoraPublicacao: DateFormat("dd/MM/yyyy HH'h'mm").parse(
        json['data_publicacao_formatada']
      ),
    );
  }

  // Fim da classe Noticia
  // 
  // Modelo de notícia com:
  // 
  // 📰 CONTEÚDO:
  // - ID único para identificação
  // - Título e resumo informativos
  // - URL de imagem para exibição
  // - Data/hora de publicação
  // 
  // 📅 TRATAMENTO DE DATA:
  // - DateFormat para parsing da API
  // - Formato brasileiro: dd/MM/yyyy HH'h'mm
  // - DateTime para manipulação e exibição
  // - Suporte a formatação customizada
  // 
  // 🔄 INTEGRAÇÃO:
  // - Factory fromJson() para API
  // - Campos imutáveis (final)
  // - Estrutura simples para listagem
  // - Compatibilidade com widgets de notícias
}
