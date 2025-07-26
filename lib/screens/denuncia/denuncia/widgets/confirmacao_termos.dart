/// CONFIRMACAO_TERMOS
///
/// Responsável por: Widget de checkbox para confirmação de termos e responsabilidade.
/// Utilizado em: Etapa final da denúncia, antes do envio.
/// 
/// Este widget contém:
/// - Checkbox circular com cores da SUDEMA
/// - Texto de declaração de responsabilidade
/// - Validação obrigatória com mensagem de erro
/// - Layout responsivo com alinhamento adequado
/// - Integração com estado do formulário

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmacaoTermos extends StatelessWidget {
  final bool confirmacao;              // Estado atual do checkbox
  final bool erroConfirmacao;          // Se deve exibir erro de validação
  final ValueChanged<bool> onChanged;  // Callback para mudanças de estado

  const ConfirmacaoTermos({
    super.key,
    required this.confirmacao,
    required this.erroConfirmacao,
    required this.onChanged,
  });

  /// Widget ConfirmacaoTermos
  ///
  /// Descrição: Interface de confirmação de responsabilidade com checkbox e validação.
  /// Obrigatório para finalizar denúncia.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox circular com cores da SUDEMA
            Transform.translate(
              offset: const Offset(-6, 0), // Ajuste de posição
              child: Checkbox(
                value: confirmacao,
                fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF2A2F8C); // Azul SUDEMA quando selecionado
                  }
                  return Colors.white; // Branco quando não selecionado
                }),
                shape: const CircleBorder(), // Formato circular
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                onChanged: (value) {
                  onChanged(value ?? false);
                },
              ),
            ),
            // Texto da declaração de responsabilidade
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
        // Mensagem de erro quando confirmação não foi feita
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
