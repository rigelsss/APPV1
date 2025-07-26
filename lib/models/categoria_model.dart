/// CATEGORIA_MODEL
///
/// Responsável por: Modelo de dados para categorias de denúncias ambientais
/// com subcategorias e imagens associadas.
/// Utilizado em: Sistema de denúncias para organizar tipos de infrações.

/// Classe CategoriaModel
///
/// Descrição: Representa uma categoria de denúncia com texto, imagem e subcategorias.
/// Estrutura: Imutável com factory constructor para parsing JSON.
class CategoriaModel {
  final String texto;              // Nome da categoria (ex: "Poluição do Ar")
  final String imagem;             // URL ou path da imagem representativa
  final List<String> subcategoria; // Lista de subcategorias específicas

  /// CONSTRUTOR
  ///
  /// Descrição: Cria instância de categoria com todos os campos obrigatórios.
  /// Parâmetros:
  /// - texto: Nome da categoria
  /// - imagem: URL/path da imagem
  /// - subcategoria: Lista de subcategorias
  CategoriaModel({
    required this.texto,
    required this.imagem,
    required this.subcategoria,
  });

  /// FROMJSON
  ///
  /// Descrição: Factory constructor para criar instância a partir de JSON da API.
  /// Parâmetros:
  /// - json: Map com dados da API
  /// Retorno: CategoriaModel configurada
  ///
  /// Mapeamento:
  /// - 'texto' → texto
  /// - 'imagem' → imagem  
  /// - 'subcategorias' → subcategoria (note o 's' no JSON)
  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      texto: json['texto'] as String,                    // Cast explícito para String
      imagem: json['imagem'] as String,                  // Cast explícito para String
      subcategoria: List<String>.from(json['subcategorias']), // Conversão de lista dinâmica
    );
  }

  // Fim da classe CategoriaModel
  // 
  // Modelo de categoria de denúncia com:
  // - Campos imutáveis (final)
  // - Factory constructor para JSON parsing
  // - Estrutura simples para categorização
  // - Suporte a subcategorias múltiplas
  // - Integração com API SUDEMA
}
