/// BALNEABILIDADE_FILTROS
///
/// Responsável por: Barra de filtros secundários da balneabilidade com seleção de município
/// e trecho/praia específica para refinar a visualização no mapa.
/// Utilizado em: Entre o header e o mapa, permite filtrar estações por localização.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudema_app/screens/balneabilidade/controller/balneabilidade_controller.dart';
import 'package:sudema_app/screens/balneabilidade/widgets/filtros_widgets.dart';
import 'package:sudema_app/screens/balneabilidade/filtros_constants.dart';

/// Widget PraiasFiltros
///
/// Descrição: Barra horizontal com dois dropdowns para filtrar por município e trecho.
/// Os filtros são hierárquicos: selecionar município atualiza opções de trechos.
class PraiasFiltros extends StatelessWidget {
  const PraiasFiltros({super.key});

  /// BUILD
  ///
  /// Descrição: Constrói barra horizontal com filtros de município e trecho.
  /// Parâmetros:
  /// - context: Contexto do widget para acesso ao Provider
  /// Retorno: Widget Padding com Row contendo os dois filtros
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BalneabilidadeController>();

    // Obtém trechos filtrados pelo município selecionado e ordena alfabeticamente
    final trechosFiltrados = controller.obterTrechosFiltrados()
      ..sort();
    // Adiciona placeholder no início da lista
    trechosFiltrados.insert(0, FiltrosLabels.trechos);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Filtro 1: Seleção de município (widget reutilizável)
          buildFiltroMunicipio(
            municipioSelecionado: controller.municipioSelecionado,
            onSelected: (value) {
              // Callback que altera município e move mapa para a região
              controller.alterarMunicipio(value, controller.filtrarMarcadores);
            },
          ),
          const SizedBox(width: 8), // Espaçamento entre filtros
          // Filtro 2: Seleção de trecho/praia específica
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label vazio para alinhar com filtro de município
                const Text("", style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                // PopupMenuButton para trechos filtrados pelo município
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    // Callback assíncrono que altera trecho e move mapa
                    await controller.alterarTrecho(value);
                  },
                  itemBuilder: (context) {
                    // Constrói lista de itens a partir dos trechos filtrados
                    return trechosFiltrados.map((trecho) {
                      return PopupMenuItem<String>(
                        value: trecho,
                        child: Text(trecho),
                      );
                    }).toList();
                  },
                  // Botão visual que mostra trecho selecionado ou placeholder
                  child: popupButton(
                    controller.praiaSelecionada.isEmpty
                        ? FiltrosLabels.trechos // Placeholder "Trechos"
                        : controller.praiaSelecionada, // Nome da praia selecionada
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
