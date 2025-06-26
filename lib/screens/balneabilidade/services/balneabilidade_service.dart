import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

class BalneabilidadeService {
  static Future<List<EstacaoMonitoramento>> carregarEstacoes() async {
    final baseUrl = dotenv.env['URL_API'];

    if (baseUrl == null || baseUrl.isEmpty) {
      throw ApiException('URL da API não configurada.');
    }

    final url = Uri.parse('$baseUrl/balneabilidade/municipios-com-trechos');

  try {
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final dados = json.decode(utf8.decode(response.bodyBytes));
      return _mapearDadosDaAPI(dados);
    } else {
      throw ApiException('Erro ao buscar dados da API: ${response.statusCode}');
    }
  } on TimeoutException {
    throw ApiException('Tempo de conexão expirado. Tente novamente.');
  } on FormatException {
    throw ApiException('Resposta da API em formato inválido.');
  } on HttpException {
    throw ApiException('Erro HTTP inesperado.');
  } on SocketException {
    throw ApiException('Falha na conexão. Verifique sua internet.');
  } catch (e) {
    throw ApiException('Erro inesperado: $e');
  }
}

  static List<EstacaoMonitoramento> _mapearDadosDaAPI(dynamic json) {
    final List<EstacaoMonitoramento> estacoes = [];

    for (var municipio in json) {
      final String nomeMunicipio = municipio['municipio'];

      for (var trecho in municipio['trechos']) {
        estacoes.add(
          EstacaoMonitoramento(
            nome: trecho['trecho'] ?? '',
            codigo: trecho['estacao'] ?? '',
            endereco: trecho['trecho'] ?? '',
            municipio: nomeMunicipio,
            coordenadas: LatLng(
              trecho['latitude'],
              trecho['longitude'],
            ),
            classificacao: trecho['classificacao']?.contains('Imprópria') == true
                ? 'Impróprias'
                : 'Próprias',
          ),
        );
      }
    }

    return estacoes;
  }
}
