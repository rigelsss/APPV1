/// MAPA_SERVICE
///
/// Responsável por: Serviços utilitários para manipulação de mapas,
/// cálculo de centros geográficos e navegação de câmera.
/// Utilizado em: Sistema de balneabilidade para controle do mapa interativo.

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';

/// Classe MapaService
///
/// Descrição: Serviços estáticos para operações geográficas e controle
/// de câmera do Google Maps.
class MapaService {
  /// CALCULARCENTROMUNICIPIO
  ///
  /// Descrição: Calcula centro geográfico (centroide) de uma lista de estações.
  /// Parâmetros:
  /// - lista: Lista de estações de monitoramento
  /// Retorno: LatLng com coordenadas do centro
  ///
  /// Cálculo: Média aritmética das latitudes e longitudes.
  /// Usado para centralizar mapa em um município.
  static LatLng calcularCentroMunicipio(List<EstacaoMonitoramento> lista) {
    // Soma todas as latitudes
    final latSum = lista.map((e) => e.coordenadas.latitude).reduce((a, b) => a + b);
    // Soma todas as longitudes
    final lngSum = lista.map((e) => e.coordenadas.longitude).reduce((a, b) => a + b);
    // Retorna média (centro geométrico)
    return LatLng(latSum / lista.length, lngSum / lista.length);
  }

  /// MOVERMAPPARAMUNICIPIO
  ///
  /// Descrição: Move câmera do mapa para centralizar em um município específico.
  /// Parâmetros:
  /// - controller: GoogleMapController para controle da câmera
  /// - estacoes: Lista completa de estações
  /// - municipio: Nome do município para filtrar
  /// - onComplete: Callback executado após movimento
  /// Retorno: Future<void>
  ///
  /// Fluxo: filtra estações → calcula centro → anima câmera → callback
  static Future<void> moverMapaParaMunicipio({
    required GoogleMapController controller,      // Controller do mapa
    required List<EstacaoMonitoramento> estacoes, // Estações completas
    required String municipio,                    // Município alvo
    required Function() onComplete,               // Callback de conclusão
  }) async {
    // Filtra estações do município selecionado
    final lista = estacoes.where((e) => e.municipio == municipio).toList();
    
    // Se há estações no município
    if (lista.isNotEmpty) {
      // Calcula centro geográfico das estações
      final destino = calcularCentroMunicipio(lista);
      // Anima câmera para o centro com zoom 12.5
      await controller.animateCamera(CameraUpdate.newLatLngZoom(destino, 12.5));
    }
    // Executa callback independente do resultado
    onComplete();
  }

  // Fim da classe MapaService
  // 
  // Serviços de mapa com:
  // 
  // 🗺️ CÁLCULOS GEOGRÁFICOS:
  // - Centro geométrico de coordenadas
  // - Média aritmética de lat/lng
  // - Centroide para visualização
  // - Algoritmo simples e eficiente
  // 
  // 📹 CONTROLE DE CÂMERA:
  // - Animação suave de movimento
  // - Zoom fixo otimizado (12.5)
  // - Filtragem por município
  // - Callback de conclusão
  // 
  // 🔧 UTILITÁRIOS:
  // - Métodos estáticos (sem estado)
  // - Integração com Google Maps
  // - Tratamento de listas vazias
  // - Operações assíncronas
}
