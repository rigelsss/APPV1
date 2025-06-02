import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TituloComLinha extends StatelessWidget {
  final String titulo;
  final bool verTodas;
  final VoidCallback? onVerTodas;

  const TituloComLinha({
    super.key,
    required this.titulo,
    this.verTodas = false,
    this.onVerTodas,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.normal),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(color: Color(0xFFB8B8B8), thickness: 2),
          ),
          if (verTodas && onVerTodas != null)
            TextButton(
              onPressed: onVerTodas,
              child: Text(
                'Ver todas',
                style: GoogleFonts.lato(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFFB8B8B8)
                ),
              ),
            ),
        ],
      ),
    );
  }
}
