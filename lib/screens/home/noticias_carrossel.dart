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
  late PageController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final larguraTela = MediaQuery.of(context).size.width;
    final isTablet = larguraTela > 600;
    final viewportFraction = isTablet ? 0.95 : 1.0;

    _controller = PageController(viewportFraction: viewportFraction);
  }

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;
    final isTablet = larguraTela > 600;
    final itensPorPagina = isTablet ? 2 : 1;

    final totalPaginas =
    (widget.noticias.length / itensPorPagina).ceil();

    return Column(
      children: [
        SizedBox(
          height: 440,
          child: PageView.builder(
            controller: _controller,
            itemCount: totalPaginas,
            onPageChanged: (index) {
              setState(() => _paginaAtual = index);
            },
            itemBuilder: (context, pageIndex) {
              final startIndex = pageIndex * itensPorPagina;
              final endIndex = (startIndex + itensPorPagina).clamp(0, widget.noticias.length);
              final noticiasPagina = widget.noticias.sublist(startIndex, endIndex);

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: noticiasPagina.map((noticia) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 380),
                        child: NoticiaCard(noticia: noticia),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalPaginas, (index) {
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
