/// FILTROS_WIDGETS
///
/// Responsável por: Fornecer widgets reutilizáveis para o sistema de filtros da balneabilidade,
/// incluindo botões de popup e filtros por município para consulta das praias monitoradas.
/// Utilizado em: Tela de balneabilidade para permitir que o usuário filtre praias por localização.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/balneabilidade/filtros_constants.dart';

/// POPUPBUTTON
///
/// Descrição: Cria um botão estilizado para PopupMenuButton com aparência consistente
/// de dropdown, incluindo borda, padding e ícone de seta para baixo.
/// Parâmetros:
/// - label: Texto a ser exibido no botão (nome do município ou placeholder)
/// Retorno: Widget Container estilizado como botão de dropdown
Widget popupButton(String label) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 1.2),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto do botão com overflow para textos longos
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis, // Evita quebra de layout
              style: const TextStyle(fontSize: 11),
            ),
          ),
          // Ícone de seta indicando dropdown
          const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        ],
      ),
    );

/// BUILDFILTROMUNICIPIO
///
/// Descrição: Constrói um widget completo de filtro por município para a consulta de balneabilidade.
/// Inclui label, PopupMenuButton com lista de municípios e callback para seleção.
/// Parâmetros:
/// - municipioSelecionado: Município atualmente selecionado (ou string vazia se nenhum)
/// - onSelected: Função callback executada quando um município é selecionado
/// Retorno: Widget Expanded com filtro completo de município
Widget buildFiltroMunicipio({
  required String municipioSelecionado, 
  required Function(String) onSelected,
}) =>
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label explicativo do filtro
          const Text("Filtrar por", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          // PopupMenuButton com lista de municípios da Paraíba que possuem praias monitoradas
          PopupMenuButton<String>(
            onSelected: onSelected, // Callback para atualizar filtro selecionado
            // Constrói lista de itens do menu a partir da constante ListaMunicipios
            itemBuilder: (_) => ListaMunicipios.nomes
                .map((m) => PopupMenuItem<String>(value: m, child: Text(m)))
                .toList(),
            // Botão visual do dropdown
            child: popupButton(
              // Exibe município selecionado ou placeholder padrão
              municipioSelecionado.isEmpty
                  ? FiltrosLabels.municipios // Placeholder "Municípios"
                  : municipioSelecionado, // Nome do município selecionado
            ),
          ),
        ],
      ),
    );
