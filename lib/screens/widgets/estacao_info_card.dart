import 'package:flutter/material.dart';
import 'package:sudema_app/services/estacoes_service.dart';

class EstacaoInfoCard extends StatelessWidget {
  final EstacaoMonitoramento estacao;
  final Offset position;

  const EstacaoInfoCard({
    super.key,
    required this.estacao,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: (position.dx - 130).clamp(16, screenWidth - 276),
      top: (position.dy - 200).clamp(16, screenHeight - 180),
      child: Material(
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
      ),
    );
  }
}
