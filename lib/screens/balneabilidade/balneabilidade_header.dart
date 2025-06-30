import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sudema_app/screens/balneabilidade/controller/balneabilidade_controller.dart';
import 'package:sudema_app/screens/balneabilidade/widgets/filtros_widgets.dart';

class PraiasHeader extends StatelessWidget {
  const PraiasHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BalneabilidadeController>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          alignment: Alignment.centerLeft,
          child: Text(
            "Balneabilidade",
            style: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w400),
          ),
        ),
        Container(
          color: Colors.grey.shade200,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Trechos monitorados",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${controller.estacoes.length}",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 200,
                height: 35,
                child: PopupMenuButton<String>(
                  onSelected: controller.toggleClassificacao,
                  itemBuilder: (_) => [
                    _radioMenuItem(context, ClassificacaoLabels.todas),
                    _radioMenuItem(context, ClassificacaoLabels.proprias),
                    _radioMenuItem(context, ClassificacaoLabels.improprias),
                  ],
                  child: popupButton(controller.getClassificacaoLabel()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _radioMenuItem(BuildContext context, String value) {
    final controller = context.read<BalneabilidadeController>();

    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: controller.getClassificacaoLabel(),
            onChanged: (_) => Navigator.pop(context, value),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
