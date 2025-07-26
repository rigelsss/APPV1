/// ESTACOES_SERVICE (OUT)
///
/// Responsável por: Serviço DESCONTINUADO para carregar estações de arquivo JSON local
/// com simulação de classificação aleatória.
/// Status: FORA DE USO - substituído por integração com API real.
/// 
/// NOTA: Este arquivo está marcado como (OUT) e não deve ser usado em produção.
/// Mantido apenas para referência histórica.

import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Classe EstacaoMonitoramento (DUPLICADA)
///
/// Descrição: Modelo duplicado - existe versão oficial em /models/
/// Status: DESCONTINUADO - usar modelo oficial
/// 
/// AVISO: Esta classe é uma duplicação desnecessária.
class EstacaoMonitoramento {
  final String nome;           // Nome da estação
  final String codigo;         // Código identificador
  final String endereco;       // Endereço da estação
  final String municipio;      // Município
  final LatLng coordenadas;    // Coordenadas geográficas
  final String classificacao;  // Classificação da água

  /// CONSTRUTOR (DUPLICADO)
  ///
  /// Descrição: Construtor idêntico ao modelo oficial.
  /// Status: DESCONTINUADO
  EstacaoMonitoramento({
    required this.nome,
    required this.codigo,
    required this.endereco,
    required this.municipio,
    required this.coordenadas,
    required this.classificacao,
  });

  /// FROMJSON (DUPLICADO)
  ///
  /// Descrição: Factory constructor para JSON local (não API).
  /// Status: DESCONTINUADO - usar modelo oficial
  /// 
  /// Diferença: Estrutura JSON diferente do modelo oficial.
  factory EstacaoMonitoramento.fromJson(Map<String, dynamic> json) {
    // Extrai coordenadas de objeto aninhado (formato local)
    final coord = json['coordenadas'] as Map<String, dynamic>;
    return EstacaoMonitoramento(
      nome: json['nome'] as String,
      codigo: json['codigo'] as String,
      endereco: json['endereco'] as String,
      municipio: json['municipio'] as String,
      coordenadas: LatLng(
        // Conversão num → double para compatibilidade
        (coord['latitude'] as num).toDouble(),
        (coord['longitude'] as num).toDouble(),
      ),
      classificacao: (json['classificacao'] as String?) ?? 'Próprias',
    );
  }
}

/// Classe EstacoesService (DESCONTINUADA)
///
/// Descrição: Serviço para carregar dados de arquivo JSON local com simulação.
/// Status: FORA DE USO - substituído por integração com API real
/// 
/// PROBLEMA: Usa dados estáticos + classificação aleatória (não real)
class EstacoesService {
  /// CARREGARESTACOES (DESCONTINUADO)
  ///
  /// Descrição: Carrega estações de arquivo JSON local com classificação FALSA.
  /// Parâmetros: nenhum
  /// Retorno: Future<List<EstacaoMonitoramento>>
  /// 
  /// PROBLEMA CRÍTICO: Usa Random() para simular classificação - dados FALSOS!
  /// Status: DESCONTINUADO - usar API real
  static Future<List<EstacaoMonitoramento>> carregarEstacoes() async {
    // Carrega arquivo JSON estático dos assets
    final jsonString =
        await rootBundle.loadString('assets/json/balneabilidade.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    final random = Random();
    // ⚠️ PROBLEMA: Adiciona classificação ALEATÓRIA (não real!)
    for (var item in jsonList) {
      item['classificacao'] =
          random.nextBool() ? 'Próprias' : 'Impróprias';  // DADOS FALSOS!
    }

    // Converte lista dinâmica para modelos tipados
    return jsonList
        .map((item) =>
            EstacaoMonitoramento.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// FILTRARESTACAESPORMUNICIPIO (DESCONTINUADO)
  ///
  /// Descrição: Filtra estações por município usando dados locais.
  /// Parâmetros:
  /// - municipio: Nome do município para filtrar
  /// Retorno: Future<List<EstacaoMonitoramento>>
  /// 
  /// Status: DESCONTINUADO - usar API com filtros reais
  static Future<List<EstacaoMonitoramento>> filtrarEstacoesPorMunicipio(
      String municipio) async {
    // Carrega todas as estações (com dados falsos)
    final estacoes = await carregarEstacoes();
    // Filtra por município (case-insensitive)
    return estacoes
        .where((e) =>
            e.municipio.toLowerCase() == municipio.toLowerCase())
        .toList();
  }

  // Fim da classe EstacoesService (DESCONTINUADA)
  // 
  // ⚠️ SERVIÇO DESCONTINUADO - NÃO USAR!
  // 
  // 🚨 PROBLEMAS CRÍTICOS:
  // - Classificação aleatória (Random.nextBool())
  // - Dados estáticos desatualizados
  // - Não reflete realidade das praias
  // - Pode causar problemas de segurança pública
  // 
  // 🔄 SUBSTITUIÇÃO:
  // - Usar integração com API SUDEMA real
  // - Modelo oficial em /models/estacao_monitoramento.dart
  // - Dados atualizados e confiáveis
  // - Classificação baseada em análises reais
  // 
  // 📋 HISTÓRICO:
  // - Usado durante desenvolvimento inicial
  // - Substituído por API real
  // - Mantido apenas para referência
  // - Arquivo marcado como (OUT)
}
