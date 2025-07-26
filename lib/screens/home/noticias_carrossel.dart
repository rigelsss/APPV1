/// NOTICIAS_CARROSSEL
///
/// Responsável por: Carrossel de notícias com layout responsivo que exibe
/// 1 notícia por página no mobile e 2 no tablet, com indicadores de navegação.
/// Utilizado em: Home para mostrar últimas notícias da SUDEMA.

import 'package:flutter/material.dart';
import 'package:sudema_app/models/noticia.dart';
import 'package:sudema_app/screens/home/noticia_card.dart';

/// Widget NoticiasCarrossel
///
/// Descrição: PageView responsivo com cards de notícias, indicadores animados
/// e adaptação automática para diferentes tamanhos de tela.
class NoticiasCarrossel extends StatefulWidget {
  final List<Noticia> noticias;  // Lista de notícias a serem exibidas

  const NoticiasCarrossel({super.key, required this.noticias});

  @override
  State<NoticiasCarrossel> createState() => _NoticiasCarrosselState();
}

class _NoticiasCarrosselState extends State<NoticiasCarrossel> {
  int _paginaAtual = 0;          // Índice da página atual do carrossel
  late PageController _controller;  // Controller do PageView (inicializado tardiamente)

  /// DIDCHANGEDEPENDENCIES
  ///
  /// Descrição: Inicializa PageController com configurações responsivas.
  /// Executado após MediaQuery estar disponível.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Configuração responsiva do carrossel
    final larguraTela = MediaQuery.of(context).size.width;
    final isTablet = larguraTela > 600;
    // Viewport menor no tablet para mostrar parte da próxima página
    final viewportFraction = isTablet ? 0.95 : 1.0;

    _controller = PageController(viewportFraction: viewportFraction);
  }

  /// BUILD
  ///
  /// Descrição: Constrói carrossel com PageView responsivo e indicadores animados.
  /// Parâmetros:
  /// - context: Contexto do widget para MediaQuery
  /// Retorno: Widget Column com carrossel e indicadores
  @override
  Widget build(BuildContext context) {
    // Configuração responsiva
    final larguraTela = MediaQuery.of(context).size.width;
    final isTablet = larguraTela > 600;
    final itensPorPagina = isTablet ? 2 : 1;  // 2 notícias no tablet, 1 no mobile

    // Calcula total de páginas baseado no número de notícias
    final totalPaginas =
    (widget.noticias.length / itensPorPagina).ceil();

    return Column(
      children: [
        // Carrossel principal
        SizedBox(
          height: 440,  // Altura fixa para manter consistência
          child: PageView.builder(
            controller: _controller,
            itemCount: totalPaginas,
            // Atualiza indicador quando página muda
            onPageChanged: (index) {
              setState(() => _paginaAtual = index);
            },
            itemBuilder: (context, pageIndex) {
              // Calcula índices das notícias para esta página
              final startIndex = pageIndex * itensPorPagina;
              final endIndex = (startIndex + itensPorPagina).clamp(0, widget.noticias.length);
              final noticiasPagina = widget.noticias.sublist(startIndex, endIndex);

              // Layout horizontal com notícias da página
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: noticiasPagina.map((noticia) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 380),  // Largura máxima
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
        // Indicadores de página animados
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalPaginas, (index) {
            final bool ativo = index == _paginaAtual;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),  // Animação suave
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Azul SUDEMA se ativo, cinza se inativo
                color: ativo ? const Color(0xFF2A2F8C) : Colors.grey.shade400,
              ),
            );
          }),
        ),
        const SizedBox(height: 10),  // Espaçamento final
      ],
    );
  }

  // Fim da classe NoticiasCarrossel
  // Carrossel responsivo com:
  // - 1 notícia por página no mobile, 2 no tablet
  // - Indicadores animados de navegação
  // - Altura fixa para consistência
  // - Integração com NoticiaCard
}

