import 'package:flutter/material.dart';
import 'package:sudema_app/models/noticia.dart';
import 'package:sudema_app/screens/home/noticia_card.dart';

class NoticiasCarrossel extends StatefulWidget {
  final List<Noticia> noticias;

  const NoticiasCarrossel({super.key, required this.noticias});

  @override
  State<NoticiasCarrossel> createState() => _NoticiasCarrosselState();
}

class _NoticiasCarrosselState extends State<NoticiasCarrossel> {
  int _paginaAtual = 0;
  final PageController _controller = PageController(viewportFraction: 1.0);

  void _irParaAnterior() {
    if (_paginaAtual > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _irParaProxima() {
    if (_paginaAtual < widget.noticias.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.noticias.length,
          onPageChanged: (index) {
            setState(() => _paginaAtual = index);
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: NoticiaCard(noticia: widget.noticias[index]),
            );
          },
        ),
      ],
    );
  }
}
