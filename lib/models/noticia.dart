class Noticia {
  final String titulo;
  final String imagemUrl;
  final String url;
  final String descricao;
  final String dataHoraPublicacao;

  Noticia({
    required this.titulo,
    required this.imagemUrl,
    required this.url,
    required this.descricao,
    required this.dataHoraPublicacao,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json['title'] ?? 'Sem título',
      imagemUrl: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
      descricao: json['description'] ?? '',
      dataHoraPublicacao: json['publishedAt'] ?? '',
    );
  }
}