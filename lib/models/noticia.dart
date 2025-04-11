class Noticia {
  final String titulo;
  final String imagemUrl;
  final String url;

  Noticia({
    required this.titulo,
    required this.imagemUrl,
    required this.url,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      titulo: json['title'] ?? 'Sem título',
      imagemUrl: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
