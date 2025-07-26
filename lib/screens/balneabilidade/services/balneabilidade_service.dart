/// BALNEABILIDADE_SERVICE
///
/// Responsável por: Integração com a API da SUDEMA para dados de balneabilidade das praias.
/// Utilizado em: Carregamento de estações de monitoramento e classificações de qualidade da água.
/// 
/// Este service gerencia:
/// - Requisições HTTP para endpoint de balneabilidade
/// - Mapeamento de dados JSON para modelos Dart
/// - Tratamento de erros específicos da API
/// - Timeout e validações de conexão
/// - Conversão de coordenadas e classificações

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/estacao_monitoramento.dart';

/// Exceção personalizada para erros da API de balneabilidade
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

class BalneabilidadeService {
  /// Integração com a API de balneabilidade
  ///
  /// Busca estações de monitoramento do endpoint:
  /// GET /balneabilidade/municipios-com-trechos
  ///
  /// Retorna lista de estações com coordenadas e classificações.
  static Future<List<EstacaoMonitoramento>> carregarEstacoes() async {
    final baseUrl = dotenv.env['URL_API'];

    if (baseUrl == null || baseUrl.isEmpty) {
      throw ApiException('URL da API não configurada.');
    }

    final url = Uri.parse('$baseUrl/balneabilidade/municipios-com-trechos');

  try {
    // Requisição com timeout de 10 segundos
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      // Decodifica resposta UTF-8 para suportar acentos
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

  /// _mapearDadosDaAPI
  ///
  /// Descrição: Converte dados JSON da API para lista de EstacaoMonitoramento.
  /// Parâmetros:
  /// - json: dados brutos da API
  /// Retorno: List<EstacaoMonitoramento> - estações mapeadas
  ///
  /// Processa estrutura hierárquica: municípios -> trechos -> estações.
  static List<EstacaoMonitoramento> _mapearDadosDaAPI(dynamic json) {
    final List<EstacaoMonitoramento> estacoes = [];

    // Itera sobre cada município retornado pela API
    for (var municipio in json) {
      final String nomeMunicipio = municipio['municipio'];

      // Itera sobre cada trecho/praia do município
      for (var trecho in municipio['trechos']) {
        estacoes.add(
          EstacaoMonitoramento(
            nome: trecho['trecho'] ?? '',
            codigo: trecho['estacao'] ?? '',
            endereco: trecho['trecho'] ?? '',
            municipio: nomeMunicipio,
            // Converte coordenadas para LatLng do Google Maps
            coordenadas: LatLng(
              trecho['latitude'],
              trecho['longitude'],
            ),
            // Classifica como Própria ou Imprópria baseado na API
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
