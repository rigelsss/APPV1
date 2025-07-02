import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class NoticiaConteudo extends StatelessWidget {
  final Map<String, dynamic> noticia;

  const NoticiaConteudo({super.key, required this.noticia});

  String _removerHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _removerHtml(noticia['titulo']),
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _removerHtml(noticia['resumo']),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Publicado: ${noticia['data_publicacao_formatada']}',
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          if (noticia['imagem_url'] != null)
            Image.network(
              noticia['imagem_url'],
              width: double.infinity,
              height: 500,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 16),
          Html(
            data: noticia['conteudo'],
            style: {
              "body": Style(
                fontSize: FontSize(14),
                fontFamily: GoogleFonts.lato().fontFamily,
              ),
            },
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: (noticia['categorias'] as List<dynamic>)
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB9CD23),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag.toString(),
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
