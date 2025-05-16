import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'fullNoticia_screen.dart';

class NoticiasPage extends StatefulWidget {
  const NoticiasPage({super.key});

  @override
  State<NoticiasPage> createState() => _NoticiasPageState();
}

class _NoticiasPageState extends State<NoticiasPage> {
  List<dynamic> noticias = [];
  List<dynamic> filtradas = [];
  Set<String> todasTags = {};
  String filtroTag = 'Tudo';
  String termoBusca = '';
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    carregarNoticias();
  }

  Future<void> carregarNoticias() async {
    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      setState(() {
        erro = '❌ URL da API não configurada.';
        carregando = false;
      });
      return;
    }

    final url = Uri.parse('$baseUrl/noticias/top30-com-tags');
    debugPrint('🌐 Requisição para: $url');

    try {
      final resposta = await http.get(url);
      debugPrint('🔁 Status: ${resposta.statusCode}');

      if (resposta.statusCode == 200) {
        final decoded = utf8.decode(resposta.bodyBytes);
        final List<dynamic> dados = json.decode(decoded);

        final categorias = <String>{};
        for (var noticia in dados) {
          final tagList = noticia['categorias'];
          if (tagList is List) {
            categorias.addAll(tagList.whereType<String>());
          }
        }

        setState(() {
          noticias = dados;
          todasTags = categorias;
          aplicarFiltro();
          carregando = false;
        });
      } else {
        setState(() {
          erro = '⚠️ Erro ${resposta.statusCode}: ${resposta.body}';
          carregando = false;
        });
      }
    } catch (e) {
      debugPrint('💥 Erro na requisição: $e');
      setState(() {
        erro = '💥 Falha na conexão com a API.';
        carregando = false;
      });
    }
  }

  void aplicarFiltro() {
    filtradas = noticias.where((n) {
      final titulo = _removerHtml(n['titulo']).toLowerCase();
      final resumo = _removerHtml(n['resumo']).toLowerCase();
      final combinaBusca = titulo.contains(termoBusca.toLowerCase()) ||
          resumo.contains(termoBusca.toLowerCase());

      final tagList = n['categorias'];
      final combinaTag = filtroTag == 'Tudo' ||
          (tagList is List && tagList.contains(filtroTag));

      return combinaBusca && combinaTag;
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

  void abrirMaisNoticias() async {
    const url = 'https://sudema.pb.gov.br/noticias';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView);
    } else {
      debugPrint('❌ Não foi possível abrir $url');
    }
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
          const Text(
            'Última notícias',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
          const Text(
            'Categorias',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...['Tudo', ...todasTags].map((tag) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          tag,
                          style: TextStyle(
                            color: filtroTag == tag ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: filtroTag == tag,
                        selectedColor: const Color(0xFF2A2F8C),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: filtroTag == tag
                                ? const Color(0xFF2A2F8C)
                                : Colors.grey,
                          ),
                        ),
                        showCheckmark: false,
                        onSelected: (_) {
                          filtroTag = tag;
                          aplicarFiltro();
                        },
                      ),
                    ))
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filtradas.length + 1,
              itemBuilder: (context, index) {
                if (index < filtradas.length) {
                  final noticia = filtradas[index];
                  final List<dynamic> categorias = noticia['categorias'] is List
                      ? noticia['categorias'].whereType<String>().toList()
                      : [];

                  return Card(
                    color: Colors.grey[200],
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          noticia['imagem_url'],
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                noticia['data_publicacao_formatada'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => abrirNoticiaCompleta(noticia['id']),
                                child: Text(
                                  _removerHtml(noticia['titulo']),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => abrirNoticiaCompleta(noticia['id']),
                                child: Text(
                                  _removerHtml(noticia['resumo']),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: categorias.map<Widget>((tag) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB9CD23),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      const Text(
                        'Deseja visualizar notícias mais antigas?',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: abrirMaisNoticias,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A2F8C),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Acesse aqui',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
