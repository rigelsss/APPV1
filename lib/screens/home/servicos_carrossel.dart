import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicosCarrossel extends StatefulWidget {
  final Function(String label) onSelecionar;

  const ServicosCarrossel({super.key, required this.onSelecionar});

  @override
  State<ServicosCarrossel> createState() => _ServicosCarrosselState();
}

class _ServicosCarrosselState extends State<ServicosCarrossel> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _abrirUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> servicos = [
      {
        'label': 'Balneabilidade',
        'image': 'assets/images/balneabilidade.png'
      },
      {
        'label': 'Denuncias',
        'image': 'assets/images/denuncia.jpg'
      },
      {
        'label': 'Transparencia',
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

    return Row(
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
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(
                            servico['image'],
                            fit: BoxFit.cover,
                            height: 80,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            servico['label'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    );
  }
}
