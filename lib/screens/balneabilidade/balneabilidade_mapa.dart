import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sudema_app/screens/balneabilidade/controller/balneabilidade_controller.dart';
import 'package:sudema_app/screens/widgets/estacao_info_card.dart';

class BalneabilidadeMapa extends StatelessWidget {
  const BalneabilidadeMapa({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BalneabilidadeController>();

    return Stack(
      children: [
        GoogleMap(
          key: controller.mapKey,
          onMapCreated: (mapController) async {
            controller.mapController = mapController;
            final zoomLevel = await mapController.getZoomLevel();
            controller.currentZoom = zoomLevel;
            controller.mapaCriado = true;

            if (controller.estacoes.isNotEmpty) {
              controller.gerarMarcadoresComSimulacao();
            }
          },
          onTap: (_) => controller.limparSelecaoEstacao(),
          onCameraMove: (pos) {
            controller.currentZoom = pos.zoom;
            controller.filtrarMarcadores();
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(-7.1202, -34.8802),
            zoom: 12.0,
          ),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          markers: {
            ...controller.marcadoresVisiveis,
            if (controller.marcadorUsuario != null && controller.currentZoom >= 14.5)
              controller.marcadorUsuario!,
          },
        ),
        if (controller.estacaoSelecionada != null && controller.overlayPosition != null)
          _buildEstacaoInfoCard(context, controller),
      ],
    );
  }

  Widget _buildEstacaoInfoCard(BuildContext context, BalneabilidadeController controller) {
    final screenSize = MediaQuery.of(context).size;
    const cardWidth = 260.0;
    const cardHeight = 160.0;
    const spacing = 12.0;

    double left = controller.overlayPosition!.dx + spacing;
    if (left + cardWidth > screenSize.width) {
      left = controller.overlayPosition!.dx - cardWidth - spacing;
    }
    left = left.clamp(8.0, screenSize.width - cardWidth - 8.0);

    double top = (controller.overlayPosition!.dy - cardHeight / 2)
        .clamp(8.0, screenSize.height - cardHeight - 8.0);

    return Positioned(
      left: left,
      top: top,
      child: EstacaoInfoCard(estacao: controller.estacaoSelecionada!),
    );
  }
}
