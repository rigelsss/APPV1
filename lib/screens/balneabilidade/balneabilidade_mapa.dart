/// BALNEABILIDADE_MAPA
///
/// Responsável por: Exibir mapa interativo do Google Maps com estações de monitoramento
/// de balneabilidade das praias da Paraíba, incluindo marcadores personalizados e overlay de informações.
/// Utilizado em: Parte principal da tela de balneabilidade, ocupando a maior parte da interface.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sudema_app/screens/balneabilidade/controller/balneabilidade_controller.dart';
import 'package:sudema_app/screens/widgets/estacao_info_card.dart';

/// Widget BalneabilidadeMapa
///
/// Descrição: Mapa interativo com estações de monitoramento, marcadores personalizados
/// e overlay de informações que aparece ao tocar em uma estação.
class BalneabilidadeMapa extends StatelessWidget {
  const BalneabilidadeMapa({super.key});

  /// BUILD
  ///
  /// Descrição: Constrói Stack com GoogleMap e overlay de informações posicionado.
  /// Parâmetros:
  /// - context: Contexto do widget para acesso ao Provider
  /// Retorno: Widget Stack com mapa e overlay condicional
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BalneabilidadeController>();

    return Stack(
      children: [
        // Mapa principal do Google Maps
        GoogleMap(
          key: controller.mapKey, // Chave para referência do widget
          // Callback executado quando mapa é criado e pronto para uso
          onMapCreated: (mapController) async {
            controller.mapController = mapController; // Salva referência do controller
            final zoomLevel = await mapController.getZoomLevel(); // Obtém zoom inicial
            controller.currentZoom = zoomLevel;
            controller.mapaCriado = true; // Marca mapa como inicializado

            // Gera marcadores se já tem estações carregadas da API
            if (controller.estacoes.isNotEmpty) {
              controller.gerarMarcadoresComSimulacao();
            }
          },
          // Callback quando usuário toca no mapa (fora dos marcadores)
          onTap: (_) => controller.limparSelecaoEstacao(), // Remove seleção e fecha overlay
          // Callback durante movimento da câmera (zoom, pan)
          onCameraMove: (pos) {
            controller.currentZoom = pos.zoom; // Atualiza zoom atual
            controller.filtrarMarcadores(); // Reaplica filtros baseado no novo zoom
          },
          // Posição inicial do mapa centralizada no litoral da Paraíba
          initialCameraPosition: const CameraPosition(
            target: LatLng(-7.1202, -34.8802), // Coordenadas de João Pessoa
            zoom: 12.0, // Zoom que mostra boa parte do litoral
          ),
          myLocationButtonEnabled: false, // Remove botão padrão de localização
          zoomControlsEnabled: false, // Remove controles de zoom padrão
          // Conjunto de marcadores exibidos no mapa
          markers: {
            // Marcadores das estações filtradas (próprias/impróprias)
            ...controller.marcadoresVisiveis,
            // Marcador da localização do usuário (apenas em zoom alto)
            if (controller.marcadorUsuario != null && controller.currentZoom >= 14.5)
              controller.marcadorUsuario!,
          },
        ),
        // Overlay de informações da estação selecionada (condicional)
        if (controller.estacaoSelecionada != null && controller.overlayPosition != null)
          _buildEstacaoInfoCard(context, controller),
      ],
    );
  }

  /// _BUILDESTACAOINFOCARD
  ///
  /// Descrição: Constrói overlay posicionado com informações da estação selecionada.
  /// Calcula posição ideal para evitar que o card saia da tela.
  /// Parâmetros:
  /// - context: Contexto para obter dimensões da tela
  /// - controller: Controller com dados da estação e posição do overlay
  /// Retorno: Widget Positioned com EstacaoInfoCard
  Widget _buildEstacaoInfoCard(BuildContext context, BalneabilidadeController controller) {
    final screenSize = MediaQuery.of(context).size;
    const cardWidth = 260.0;  // Largura fixa do card
    const cardHeight = 160.0; // Altura fixa do card
    const spacing = 12.0;     // Espaçamento do marcador

    // Calcula posição horizontal (preferência: direita do marcador)
    double left = controller.overlayPosition!.dx + spacing;
    // Se card sairia da tela, posiciona à esquerda do marcador
    if (left + cardWidth > screenSize.width) {
      left = controller.overlayPosition!.dx - cardWidth - spacing;
    }
    // Garante que card não saia das bordas horizontais
    left = left.clamp(8.0, screenSize.width - cardWidth - 8.0);

    // Calcula posição vertical (centralizada no marcador)
    double top = (controller.overlayPosition!.dy - cardHeight / 2)
        .clamp(8.0, screenSize.height - cardHeight - 8.0); // Garante que não saia das bordas verticais

    return Positioned(
      left: left,
      top: top,
      // Card com informações detalhadas da estação
      child: EstacaoInfoCard(estacao: controller.estacaoSelecionada!),
    );
  }
}
