import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmacaoTermos extends StatelessWidget {
  final bool confirmacao;
  final bool erroConfirmacao;
  final ValueChanged<bool> onChanged;

  const ConfirmacaoTermos({
    super.key,
    required this.confirmacao,
    required this.erroConfirmacao,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: const Offset(-6, 0),
              child: Checkbox(
                value: confirmacao,
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF2A2F8C); 
                  }
                  return Colors.white; 
                }),
                shape: const CircleBorder(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                onChanged: (value) {
                  onChanged(value ?? false);
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Text(
                  'Declaro que as informações acima prestadas são verdadeiras, e assumo a inteira responsabilidade pelas mesmas.',
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (erroConfirmacao)
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 4),
            child: Text(
              'Você deve aceitar os termos para continuar.',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
