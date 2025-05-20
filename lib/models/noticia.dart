import 'package:intl/intl.dart';


class Noticia {
  final String id;
  final String titulo;
  final String resumo;
  final String imagemUrl;
  final DateTime dataHoraPublicacao; 

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
      dataHoraPublicacao: DateFormat("dd/MM/yyyy HH'h'mm").parse(json['data_publicacao_formatada']),
    );
  }
}
