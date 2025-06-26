import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudema_app/screens/balneabilidade/controller/balneabilidade_controller.dart';
import 'package:sudema_app/screens/balneabilidade/widgets/filtros_widgets.dart';
import 'package:sudema_app/screens/balneabilidade/filtros_constants.dart';


class PraiasFiltros extends StatelessWidget {
  const PraiasFiltros({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BalneabilidadeController>();

    final trechosFiltrados = controller.obterTrechosFiltrados()
      ..sort();
    trechosFiltrados.insert(0, FiltrosLabels.trechos);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          buildFiltroMunicipio(
            municipioSelecionado: controller.municipioSelecionado,
            onSelected: (value) {
              controller.alterarMunicipio(value, controller.filtrarMarcadores);
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("", style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    await controller.alterarTrecho(value);
                  },
                  itemBuilder: (context) {
                    return trechosFiltrados.map((trecho) {
                      return PopupMenuItem<String>(
                        value: trecho,
                        child: Text(trecho),
                      );
                    }).toList();
                  },
                  child: popupButton(
                    controller.praiaSelecionada.isEmpty
                        ? FiltrosLabels.trechos
                        : controller.praiaSelecionada,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
