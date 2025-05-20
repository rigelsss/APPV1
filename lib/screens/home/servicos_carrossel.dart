import 'package:flutter/material.dart';

class ServicosCarrossel extends StatelessWidget {
  final void Function(String label) onSelecionar;

  const ServicosCarrossel({
    super.key,
    required this.onSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final servicos = [
      {'label': 'Balneabilidade', 'img': 'assets/images/bauneabilidade.jpg'},
      {'label': 'Denuncias', 'img': 'assets/images/fiscalizacao.jpg'},
      {'label': 'Portal da Transparência', 'img': 'assets/images/portaltransparencia.jpg'},
      {'label': 'Educação Ambiental', 'img': 'assets/images/educacao_ambiental.jpg'},
      {'label': 'Licenciamento', 'img': 'assets/images/licenciamento.jpg'},
    ];

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: screenWidth * 0.9,
        height: 130,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: servicos.map((servico) {
            return _buildServiceCardComImagem(
              label: servico['label']!,
              imagePath: servico['img']!,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildServiceCardComImagem({
    required String label,
    required String imagePath,
  }) {
    return InkWell(
      onTap: () => onSelecionar(label),
      borderRadius: BorderRadius.circular(12),
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
              child: Image.asset(imagePath, fit: BoxFit.cover, height: 80),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
