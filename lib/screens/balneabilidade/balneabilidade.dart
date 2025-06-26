import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudema_app/screens/balneabilidade/controller/balneabilidade_controller.dart';
import 'package:sudema_app/screens/balneabilidade/balneabilidade_header.dart';
import 'package:sudema_app/screens/balneabilidade/balneabillidade_filtros.dart';
import 'package:sudema_app/screens/balneabilidade/balneabilidade_mapa.dart';

class Balneabilidade extends StatelessWidget {
  const Balneabilidade({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BalneabilidadeController()..inicializar(),
      builder: (context, _) {
        final controller = context.watch<BalneabilidadeController>();

        if (controller.isLoadingEstacoes) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              const PraiasHeader(),
              const PraiasFiltros(),
              Expanded(child: BalneabilidadeMapa()),
            ],
          ),
        );
      },
    );
  }
}
