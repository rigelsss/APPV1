/// DENUNCIA_MENU_SUPERIOR
///
/// Responsável por: Widget de navegação superior mostrando as etapas do fluxo de denúncias.
/// Utilizado em: Tela de resumo para mostrar progresso completo do fluxo.
/// 
/// Este widget contém:
/// - Lista das 4 etapas do fluxo de denúncias
/// - Indicador visual da etapa atual (quando aplicável)
/// - Layout responsivo com texto que se ajusta ao espaço
/// - Bordas inferiores para indicar progresso
/// - Cores diferenciadas para etapa ativa vs inativas

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DenunciaMenuSuperior extends StatelessWidget {
  final int etapaAtual; // Índice da etapa atual (-1 para nenhuma selecionada)

  const DenunciaMenuSuperior({super.key, required this.etapaAtual});

  // Lista das 4 etapas do fluxo de denúncias
  final List<String> _etapas = const [
    'Identificação',
    'Categoria',
    'Localização',
    'Denúncia'
  ];

  /// Widget DenunciaMenuSuperior
  ///
  /// Descrição: Barra de navegação horizontal com as etapas do fluxo.
  /// Mostra progresso visual e permite identificação da etapa atual.
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
                  // Borda verde para etapa ativa, cinza para inativas
                  color: selecionado ? const Color(0xFF1B8C00) : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
            ),
            child: FittedBox(
            fit: BoxFit.scaleDown, // Ajusta texto ao espaço disponível
            child: Text(
              _etapas[index],
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 14,
                // Negrito para etapa ativa, normal para inativas
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
                // Preto para etapa ativa, cinza para inativas
                color: selecionado ? Colors.black : Colors.grey,
              ),
            ),
          ),
          ),
        );
      }),
    );
  }
}
