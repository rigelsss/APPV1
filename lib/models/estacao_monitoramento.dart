import 'package:google_maps_flutter/google_maps_flutter.dart';

class EstacaoMonitoramento {
  final String nome;
  final String codigo;
  final String endereco;
  final String municipio;
  final LatLng coordenadas;
  final String classificacao;

  EstacaoMonitoramento({
    required this.nome,
    required this.codigo,
    required this.endereco,
    required this.municipio,
    required this.coordenadas,
    required this.classificacao,
  });

  // Construtor de fallback vazio para evitar erro em `firstWhere`
  factory EstacaoMonitoramento.vazio() {
    return EstacaoMonitoramento(
      nome: '',
      codigo: '',
      endereco: '',
      municipio: '',
      coordenadas: const LatLng(0.0, 0.0),
      classificacao: '',
    );
  }

  // Método opcional para quando quiser carregar diretamente do JSON
  factory EstacaoMonitoramento.fromJson(Map<String, dynamic> json, String municipio) {
    return EstacaoMonitoramento(
      nome: json['trecho'] ?? '',
      codigo: json['estacao'] ?? '',
      endereco: json['trecho'] ?? '',
      municipio: municipio,
      coordenadas: LatLng(
        json['latitude']?.toDouble() ?? 0.0,
        json['longitude']?.toDouble() ?? 0.0,
      ),
      classificacao: json['classificacao'] ?? 'Próprias',
    );
  }
}
