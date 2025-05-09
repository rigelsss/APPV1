import 'package:flutter/material.dart';
import 'package:sudema_app/services/estacoes_service.dart';

class EstacaoInfoCard extends StatelessWidget {
  final EstacaoMonitoramento estacao;

  const EstacaoInfoCard({super.key, required this.estacao});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${estacao.nome} - ${estacao.municipio}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              estacao.endereco,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Estação: ${estacao.codigo}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              estacao.classificacao == 'Próprias'
                  ? 'Própria para banho'
                  : 'Imprópria para banho',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: estacao.classificacao == 'Próprias'
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
