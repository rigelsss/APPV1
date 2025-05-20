import 'package:flutter/material.dart';

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

PopupMenuItem<String> popupItem(BuildContext context, String label, bool isChecked) =>
    PopupMenuItem<String>(
      value: label,
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (_) => Navigator.pop(context, label),
          ),
          Flexible(child: Text(label)),
        ],
      ),
    );

Widget buildFiltroMunicipio({
  required String municipioSelecionado,
  required Function(String) onSelected,
}) =>
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filtrar por", style: TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          PopupMenuButton<String>(
            onSelected: onSelected,
            itemBuilder: (_) => [
              'Todos',
              'Mataraca',
              'Baia da Traição',
              'Rio Tinto',
              'Lucena',
              'Cabedelo',
              'João Pessoa',
              'Conde',
              'Pitimbú'
            ].map((m) => PopupMenuItem<String>(value: m, child: Text(m))).toList(),
            child: popupButton(municipioSelecionado.isEmpty ? 'Municípios' : municipioSelecionado),
          ),
        ],
      ),
    );

Widget buildFiltroPraia() => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          popupButton("Trecho"),
        ],
      ),
    );
