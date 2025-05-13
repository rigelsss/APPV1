import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
        final decoded = const Latin1Decoder().convert(resposta.bodyBytes);
        final List<dynamic> dados = json.decode(decoded);

        final tags = <String>{};
        for (var noticia in dados) {
          tags.addAll(List<String>.from(noticia['tags']));
        }

        setState(() {
          noticias = dados;
          todasTags = tags;
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
      final combinaTag =
          filtroTag == 'Tudo' || (n['tags'] as List).contains(filtroTag);
      return combinaBusca && combinaTag;
    }).toList();
    setState(() {});
  }

  String _removerHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
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
            'Notícias',
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
              fillColor: Colors.grey[400],
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
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
                ...['Tudo', ...todasTags]
                    .map((tag) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(tag),
                            selected: filtroTag == tag,
                            onSelected: (_) {
                              filtroTag = tag;
                              aplicarFiltro();
                            },
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filtradas.length,
              itemBuilder: (context, index) {
                final noticia = filtradas[index];
                return Card(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        noticia['imagem_url'],
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _removerHtml(noticia['titulo']),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
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
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
