class Noticia {
  final String id;
  final String titulo;
  final String resumo;
  final String imagemUrl;
  final String dataHoraPublicacao;

  Noticia({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.imagemUrl,
    required this.dataHoraPublicacao,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      id: json['id'].toString(),
      titulo: json['titulo'],
      resumo: json['resumo'],
      imagemUrl: json['imagem_url'],
      dataHoraPublicacao: json['data_publicacao'],
    );
  }
}
