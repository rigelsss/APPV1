import 'package:flutter/material.dart';
import 'package:sudema_app/screens/noticias/pagina_noticiaCompleta/noticia_conteudo.dart';
import 'package:sudema_app/screens/noticias/pagina_noticiaCompleta/controller/noticiaCompleta_controller.dart';


class NoticiaCompletaPage extends StatefulWidget {
  final dynamic id;

  const NoticiaCompletaPage({super.key, required this.id});

  @override
  State<NoticiaCompletaPage> createState() => _NoticiaCompletaPageState();
}

class _NoticiaCompletaPageState extends State<NoticiaCompletaPage> {
  final NoticiaController _controller = NoticiaController();

  @override
  void initState() {
    super.initState();
    _controller.carregarNoticia(widget.id).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _controller.carregando
          ? const Center(child: CircularProgressIndicator())
          : _controller.erro != null
              ? Center(
                  child: Text(
                    _controller.erro!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _controller.noticia == null
                  ? const Center(child: Text('❌ Notícia não encontrada.'))
                  : NoticiaConteudo(noticia: _controller.noticia!),
    );
  }
}
