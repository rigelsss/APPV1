import 'package:flutter/material.dart';
import 'package:sudema_app/screens/balneabilidade/filtros_constants.dart';

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
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        ],
      ),
    );

Widget buildFiltroMunicipio({required String municipioSelecionado, required Function(String) onSelected,}) =>
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filtrar por", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          PopupMenuButton<String>(
            onSelected: onSelected,
            itemBuilder: (_) => ListaMunicipios.nomes
                .map((m) => PopupMenuItem<String>(value: m, child: Text(m)))
                .toList(),
            child: popupButton(
              municipioSelecionado.isEmpty
                  ? FiltrosLabels.municipios
                  : municipioSelecionado,
            ),
          ),
        ],
      ),
    );
