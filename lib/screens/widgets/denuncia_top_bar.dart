import 'package:flutter/material.dart';

class DenunciaTopBar extends StatelessWidget {
  final List<String> opcoes;
  final int selectedIndex;
  final bool Function(int) podeIrParaAba;
  final Function(int) onSelecionar;

  const DenunciaTopBar({
    super.key,
    required this.opcoes,
    required this.selectedIndex,
    required this.podeIrParaAba,
    required this.onSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(opcoes.length, (index) {
          final isSelected = index == selectedIndex;
          final isEnabled = podeIrParaAba(index);

          return GestureDetector(
            onTap: () => onSelecionar(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  opcoes[index],
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? Colors.blue[900]
                        : isEnabled
                            ? Colors.grey[700]
                            : Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 3,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[900] : Colors.transparent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
