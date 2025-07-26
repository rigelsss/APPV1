/// BALNEABILIDADE
///
/// Responsável por: Tela principal do módulo de balneabilidade das praias da Paraíba.
/// Utilizado em: Aba "Balneabilidade" da navegação principal do aplicativo SUDEMA.
/// 
/// Esta tela apresenta:
/// - Mapa interativo com estações de monitoramento
/// - Sistema de filtros por município, praia e classificação
/// - Dados de qualidade da água das praias paraibanas
/// - Integração com API da SUDEMA para dados atualizados
/// - Interface responsiva com header, filtros e mapa
/// - Gerenciamento de estado via Provider pattern

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudema_app/screens/balneabilidade/controller/balneabilidade_controller.dart';
import 'package:sudema_app/screens/balneabilidade/balneabilidade_header.dart';
import 'package:sudema_app/screens/balneabilidade/balneabillidade_filtros.dart';
import 'package:sudema_app/screens/balneabilidade/balneabilidade_mapa.dart';

class Balneabilidade extends StatelessWidget {
  const Balneabilidade({super.key});

  /// Widget Balneabilidade
  ///
  /// Descrição: Interface principal do módulo com Provider para gerenciamento de estado.
  /// Estrutura vertical com header, filtros e mapa interativo.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Cria e inicializa o controller com dados da API
      create: (_) => BalneabilidadeController()..inicializar(),
      builder: (context, _) {
        final controller = context.watch<BalneabilidadeController>();

        // Exibe loading enquanto carrega estações da API
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
              // Header com título e informações
              const PraiasHeader(),
              // Barra de filtros por município, praia e classificação
              const PraiasFiltros(),
              // Mapa interativo com estações de monitoramento
              Expanded(child: BalneabilidadeMapa()),
            ],
          ),
        );
      },
    );
  }
}
