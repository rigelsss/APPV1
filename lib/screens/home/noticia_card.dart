/// NOTICIA_CARD
///
/// Responsável por: Card individual de notícia com imagem, título, resumo e data,
/// otimizado para diferentes tamanhos de tela e com navegação para tela completa.
/// Utilizado em: Carrossel de notícias na home e listas de notícias.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sudema_app/models/noticia.dart';
import 'package:sudema_app/screens/noticias/pagina_noticiaCompleta/noticiaCompleta_screen.dart';

/// Widget NoticiaCard
///
/// Descrição: Card responsivo com imagem em cache, informações da notícia
/// e navegação ao tocar para visualização completa.
class NoticiaCard extends StatelessWidget {
  final Noticia noticia;  // Modelo de notícia com dados completos

  const NoticiaCard({super.key, required this.noticia});

  /// BUILD
  ///
  /// Descrição: Constrói card responsivo com imagem, data e conteúdo da notícia.
  /// Parâmetros:
  /// - context: Contexto do widget para MediaQuery e navegação
  /// Retorno: Widget GestureDetector com card completo
  @override
  Widget build(BuildContext context) {
    // Formatação de data e hora para exibição
    final data = noticia.dataHoraPublicacao;
    final dataFormatada =
        "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";
    final horaFormatada =
        "${data.hour.toString().padLeft(2, '0')}h${data.minute.toString().padLeft(2, '0')}";

    // Configuração responsiva
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;

    return GestureDetector(
      // Navega para tela completa da notícia ao tocar
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => NoticiaCompletaPage(id: noticia.id)),
        );
      },
      child: Container(
        // Largura responsiva: maior no tablet, quase total no mobile
        width: isTablet ? screenWidth * 0.6 : screenWidth * 0.97,
        margin: EdgeInsets.symmetric(
          horizontal: isTablet ? 10 : 0,  // Margem lateral apenas no tablet
          vertical: isTablet ? 12 : 0,    // Margem vertical apenas no tablet
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),  // Borda sutil
          borderRadius: BorderRadius.circular(16),           // Bordas arredondadas
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),  // Sombra leve
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção da imagem com bordas arredondadas no topo
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: noticia.imagemUrl,
                height: isTablet ? 246 : 262.48,  // Altura responsiva
                width: double.infinity,            // Largura total
                fit: BoxFit.cover,                 // Preenche mantendo proporção
                // Loading placeholder
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                // Error fallback
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            // Seção do conteúdo com fundo cinza claro
            Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 238, 238, 238),  // Fundo cinza claro
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(16)),  // Bordas arredondadas embaixo
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Data e hora alinhadas à direita
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "$dataFormatada   $horaFormatada",
                        style: GoogleFonts.lato(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Título da notícia (máximo 3 linhas)
                    Text(
                      noticia.titulo,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,  // Reticências se exceder
                    ),
                    const SizedBox(height: 4),
                    // Resumo da notícia (máximo 4 linhas)
                    Text(
                      noticia.resumo,
                      style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Color.fromARGB(255, 120, 120, 120)),  // Cinza escuro
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,  // Reticências se exceder
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fim da classe NoticiaCard
  // Card responsivo com:
  // - Imagem em cache com placeholder e error handling
  // - Data/hora formatadas
  // - Título e resumo com limitação de linhas
  // - Navegação para tela completa
  // - Layout adaptativo mobile/tablet
}
