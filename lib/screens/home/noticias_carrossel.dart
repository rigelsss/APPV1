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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.4, 
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.noticias.length,
            onPageChanged: (index) {
              setState(() => _paginaAtual = index);
            },
            itemBuilder: (context, index) {
              return NoticiaCard(noticia: widget.noticias[index]);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.noticias.length, (index) {
            final bool ativo = index == _paginaAtual;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ativo ? const Color(0xFF2A2F8C) : Colors.grey.shade400,
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
