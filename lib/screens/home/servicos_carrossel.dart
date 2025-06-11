import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicosCarrossel extends StatefulWidget {
  final Function(String label) onSelecionar;

  const ServicosCarrossel({super.key, required this.onSelecionar});

  @override
  State<ServicosCarrossel> createState() => _ServicosCarrosselState();
}

class _ServicosCarrosselState extends State<ServicosCarrossel> {
  final ScrollController _scrollController = ScrollController();
  int _indiceAtual = 0;

  final List<Map<String, dynamic>> servicos = [
    {
      'label': 'Balneabilidade', 
      'image': 'assets/images/balneabilidade.png'
    },
    {
      'label': 'Denúncias', 
      'image': 'assets/images/denuncia.jpg'
    },
    {
      'label': 'Transparência',
      'image': 'assets/images/portaltransparencia.jpg',
      'url': 'https://sigma.pb.gov.br/transparencia/'
    },
    {
      'label': 'Licenciamento',
      'image': 'assets/images/licenciamento.jpg',
      'url': 'https://sigma.pb.gov.br/index/'
    },
    {
      'label': 'CTE',
      'image': 'assets/images/CTE.jpg',
      'url': 'https://cte.sigma.pb.gov.br/'
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_atualizarIndice);
  }

  void _atualizarIndice() {
    final posicao = _scrollController.offset;
    setState(() {
      _indiceAtual = posicao < 120 * 2 ? 0 : 1; 
    });
  }

  Future<void> _abrirUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_atualizarIndice);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 130,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: servicos.length,
                  itemBuilder: (context, index) {
                    final servico = servicos[index];
                    return GestureDetector(
                      onTap: () {
                        if (servico.containsKey('url')) {
                          _abrirUrl(servico['url']);
                        } else {
                          widget.onSelecionar(servico['label']);
                        }
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              child: Image.asset(
                                servico['image'],
                                fit: BoxFit.cover,
                                height: 80,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                servico['label'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIndicador(ativo: _indiceAtual == 0),
            const SizedBox(width: 8),
            _buildIndicador(ativo: _indiceAtual == 1),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicador({required bool ativo}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 30,
      height: 6,
      decoration: BoxDecoration(
        color: ativo ? const Color(0xFF2A2F8C) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
