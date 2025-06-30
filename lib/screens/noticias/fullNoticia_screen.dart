import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';


class NoticiaCompletaPage extends StatefulWidget {
  final dynamic id;

  const NoticiaCompletaPage({super.key, required this.id});

  @override
  State<NoticiaCompletaPage> createState() => _NoticiaCompletaPageState();
}

class _NoticiaCompletaPageState extends State<NoticiaCompletaPage> {
  Map<String, dynamic>? noticia;
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    carregarNoticia();
  }

  Future<void> carregarNoticia() async {
    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      setState(() {
        erro = '❌ URL da API não configurada.';
        carregando = false;
      });
      return;
    }

    final url = Uri.parse('$baseUrl/noticias/${widget.id}');
    try {
      final resposta = await http.get(url);

      if (resposta.statusCode == 200) {
        final decoded = utf8.decode(resposta.bodyBytes);
        setState(() {
          noticia = json.decode(decoded);
          carregando = false;
        });
      } else {
        setState(() {
          erro = '⚠️ Erro ${resposta.statusCode}: ${resposta.body}';
          carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        erro = '💥 Falha ao carregar a notícia.';
        carregando = false;
      });
    }
  }

  String _removerHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : erro != null
              ? Center(
                  child: Text(
                    erro!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : noticia == null
                  ? const Center(child: Text('❌ Notícia não encontrada.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _removerHtml(noticia!['titulo']),
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _removerHtml(noticia!['resumo']),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w300
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Publicado: ${noticia!['data_publicacao_formatada']}',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (noticia!['imagem_url'] != null)
                            Image.network(
                              noticia!['imagem_url'],
                              width: double.infinity,
                              height: 500,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 16),
                          Html(
                            data: noticia!['conteudo'],
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
                            children: (noticia!['categorias'] as List<dynamic>)
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
                    ),
    );
  }
}
