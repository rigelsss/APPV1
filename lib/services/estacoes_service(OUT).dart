import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
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

  factory EstacaoMonitoramento.fromJson(Map<String, dynamic> json) {
    // aqui definimos coord a partir do JSON
    final coord = json['coordenadas'] as Map<String, dynamic>;
    return EstacaoMonitoramento(
      nome: json['nome'] as String,
      codigo: json['codigo'] as String,
      endereco: json['endereco'] as String,
      municipio: json['municipio'] as String,
      coordenadas: LatLng(
        // convertendo num para double, caso venha int
        (coord['latitude'] as num).toDouble(),
        (coord['longitude'] as num).toDouble(),
      ),
      classificacao: (json['classificacao'] as String?) ?? 'Próprias',
    );
  }
}

class EstacoesService {
  /// Carrega todo o JSON e simula classificação aleatória
  static Future<List<EstacaoMonitoramento>> carregarEstacoes() async {
    final jsonString =
        await rootBundle.loadString('assets/json/balneabilidade.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    final random = Random();
    // Adiciona classificação simulada no próprio objeto JSON
    for (var item in jsonList) {
      item['classificacao'] =
          random.nextBool() ? 'Próprias' : 'Impróprias';
    }

    // Converte cada mapa em EstacaoMonitoramento via fromJson
    return jsonList
        .map((item) =>
            EstacaoMonitoramento.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Opcional: filtra por município
  static Future<List<EstacaoMonitoramento>> filtrarEstacoesPorMunicipio(
      String municipio) async {
    final estacoes = await carregarEstacoes();
    return estacoes
        .where((e) =>
            e.municipio.toLowerCase() == municipio.toLowerCase())
        .toList();
  }
}
