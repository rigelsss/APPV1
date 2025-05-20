import 'package:flutter/material.dart';

class TituloComLinha extends StatelessWidget {
  final String titulo;
  final bool verTodas;
  final VoidCallback? onVerTodas;

  const TituloComLinha({
    super.key,
    required this.titulo,
    this.verTodas = false,
    this.onVerTodas,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Divider(color: Colors.grey, thickness: 2),
          ),
          if (verTodas && onVerTodas != null)
            TextButton(
              onPressed: onVerTodas,
              child: const Text(
                'Ver todas',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
