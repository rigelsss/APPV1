class CategoriaModel {
  final String texto;
  final String imagem;
  final List<String> subcategoria;

  CategoriaModel({
    required this.texto,
    required this.imagem,
    required this.subcategoria,
  });

  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      texto: json['texto'] as String,
      imagem: json['imagem'] as String,
      subcategoria: List<String>.from(json['subcategorias']),
    );
  }
}
