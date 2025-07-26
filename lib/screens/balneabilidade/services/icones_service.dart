/// ICONES_SERVICE
///
/// Responsável por: Carregar ícones personalizados para marcadores do mapa de balneabilidade.
/// Utilizado em: Controller de balneabilidade para criar marcadores com visual diferenciado.

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IconesService {
  /// CARREGARICONEPROPRIA
  ///
  /// Descrição: Carrega ícone verde para praias com classificação "Própria".
  /// Retorno: Future<BitmapDescriptor> - ícone otimizado para o mapa
  static Future<BitmapDescriptor> carregarIconePropria() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)), // Tamanho otimizado para visualização
      'assets/images/propria.png', // Ícone verde indicando água própria
    );
  }

  /// CARREGARICONEIMPROPRIA
  ///
  /// Descrição: Carrega ícone vermelho para praias com classificação "Imprópria".
  /// Retorno: Future<BitmapDescriptor> - ícone otimizado para o mapa
  static Future<BitmapDescriptor> carregarIconeImpropria() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)), // Tamanho otimizado para visualização
      'assets/images/impropria.png', // Ícone vermelho indicando água imprópria
    );
  }

  /// CARREGARICONEUSUARIO
  ///
  /// Descrição: Carrega ícone azul para marcar a localização atual do usuário.
  /// Retorno: Future<BitmapDescriptor> - ícone otimizado para o mapa
  static Future<BitmapDescriptor> carregarIconeUsuario() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 3.0), // Alta resolução para nitidez
      'assets/images/circle_user_location.png', // Ícone circular azul do usuário
    );
  }
}
