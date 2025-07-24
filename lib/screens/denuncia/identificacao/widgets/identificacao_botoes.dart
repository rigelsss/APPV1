import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdentificacaoBotoes extends StatelessWidget {
  final VoidCallback onSelecionarAnonimo;
  final VoidCallback onSelecionarIdentificado;
  final bool anonimo;
  final String? usuarioEmail;

  const IdentificacaoBotoes({
    super.key,
    required this.onSelecionarAnonimo,
    required this.onSelecionarIdentificado,
    required this.anonimo,
    required this.usuarioEmail,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;

        final Widget conteudo = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Você acessou o sistema como ',
                    style: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  TextSpan(
                    text: usuarioEmail ?? '',
                    style: GoogleFonts.lato(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: onSelecionarIdentificado,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  anonimo ? Colors.white : const Color(0xFF2A2F8C),
                  foregroundColor:
                  anonimo ? const Color(0xFF2A2F8C) : Colors.white,
                  side: const BorderSide(color: Color(0xFF2A2F8C), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Prosseguir com identificação',
                  style: GoogleFonts.lato(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: onSelecionarAnonimo,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  anonimo ? const Color(0xFF2A2F8C) : Colors.white,
                  foregroundColor:
                  anonimo ? Colors.white : const Color(0xFF2A2F8C),
                  side: const BorderSide(color: Color(0xFF2A2F8C), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Continuar de forma anônima',
                  style: GoogleFonts.lato(fontSize: 16),
                ),
              ),
            ),
          ],
        );

        if (isTablet) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: conteudo,
            ),
          );
        }

        return conteudo;
      },
    );
  }
}
