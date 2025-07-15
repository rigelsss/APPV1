import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DenunciaMenuSuperior extends StatelessWidget {
  final int etapaAtual;

  const DenunciaMenuSuperior({super.key, required this.etapaAtual});

  final List<String> _etapas = const [
    'Identificação',
    'Categoria',
    'Localização',
    'Denúncia'
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_etapas.length, (index) {
        final selecionado = index == etapaAtual;
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selecionado ? const Color(0xFF1B8C00) : Colors.grey.shade300,
                  width: 2.5,
                ),
              ),
            ),
            child: Text(
              _etapas[index],
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
                color: selecionado ? Colors.black : Colors.grey,
              ),
            ),
          ),
        );
      }),
    );
  }
}
