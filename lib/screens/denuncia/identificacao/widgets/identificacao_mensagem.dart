import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IdentificacaoMensagem extends StatelessWidget {
  final VoidCallback onLogin;

  const IdentificacaoMensagem({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;

        final Widget conteudo = Column(
          crossAxisAlignment:
          isTablet ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              'É necessário acessar o sistema para realizar uma denúncia. Após o login você pode escolher fazer a denúncia de forma anônima.',
              style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w300),
              textAlign: isTablet ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2F8C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Acessar o sistema',
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.white),
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
