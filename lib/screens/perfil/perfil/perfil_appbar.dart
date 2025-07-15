import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PerfilHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? nome;

  const PerfilHeader({required this.nome, super.key});

  @override
  Widget build(BuildContext context) {
    final primeiroNome = (nome ?? 'Nome não encontrado').split(' ').first;

    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      title: Text(
        'Olá, $primeiroNome',
        style: GoogleFonts.lato(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      scrolledUnderElevation: 0, 
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
