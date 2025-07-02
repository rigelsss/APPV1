import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sudema_app/screens/noticias/pagina_noticias/service/noticias_service.dart';
import 'package:sudema_app/screens/noticias/pagina_noticias/model/noticia_card.dart';
import 'package:sudema_app/screens/noticias/pagina_noticias/widget/widget_textoBotao.dart';

import '../pagina_noticiaCompleta/noticiaCompleta_screen.dart';

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  State<NoticiasPage> createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  List<dynamic> noticias = [];
  List<dynamic> filtradas = [];
  String termoBusca = '';
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    carregarNoticias();
  }

  Future<void> carregarNoticias() async {
    try {
      final dados = await NoticiasService.carregarNoticias();
      setState(() {
        noticias = dados;
        aplicarFiltro();
        carregando = false;
      });
    } catch (e) {
      debugPrint('💥 Erro na requisição: $e');
      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  void aplicarFiltro() {
    filtradas = noticias.where((n) {
      final titulo = _removerHtml(n['titulo']).toLowerCase();
      final resumo = _removerHtml(n['resumo']).toLowerCase();
      return titulo.contains(termoBusca.toLowerCase()) ||
          resumo.contains(termoBusca.toLowerCase());
    }).toList();
    setState(() {});
  }

  String _removerHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  void abrirNoticiaCompleta(dynamic id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoticiaCompletaPage(id: id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (erro != null) {
      return Center(
        child: Text(
          erro!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Últimas notícias',
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (valor) {
              termoBusca = valor;
              aplicarFiltro();
            },
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              filled: true,
              fillColor: Colors.grey[100],
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filtradas.length + 1,
              itemBuilder: (context, index) {
                if (index < filtradas.length) {
                  final noticia = filtradas[index];
                  return NoticiaCard(
                    noticia: noticia,
                    onTap: () => abrirNoticiaCompleta(noticia['id']),
                    removerHtml: _removerHtml,
                  );
                } else {
                  return const NoticiasMaisAntigas();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
