import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/utils/logout_helper.dart';

class PerfilFooterButtons extends StatelessWidget {
  final VoidCallback onLogout;

  const PerfilFooterButtons({
    required this.onLogout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              confirmarLogout(context, onLogout: onLogout);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: Text(
              'Sair',
              style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2F8C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/deletar-conta');
          },
          icon: SvgPicture.asset(
            'assets/icon/lixo.svg',
            width: 22,
            height: 22,
          ),
          label: Text(
            'Desativar Conta',
            style: GoogleFonts.lato(fontSize: 14, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
