/// ESTACAO_MONITORAMENTO
///
/// Responsável por: Modelo de dados para estações de monitoramento de balneabilidade
/// das praias paraibanas com localização e classificação.
/// Utilizado em: Sistema de balneabilidade para exibir dados das praias.

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Classe EstacaoMonitoramento
///
/// Descrição: Representa uma estação de monitoramento de qualidade da água
/// com localização geográfica e classificação atual.
class EstacaoMonitoramento {
  final String nome;           // Nome da praia/trecho monitorado
  final String codigo;         // Código identificador da estação
  final String endereco;       // Endereço ou descrição do local
  final String municipio;      // Município onde está localizada
  final LatLng coordenadas;    // Coordenadas geográfica (lat, lng)
  final String classificacao;  // Classificação: "Próprias" ou "Impróprias"

  /// CONSTRUTOR
  ///
  /// Descrição: Cria instância de estação com todos os campos obrigatórios.
  /// Parâmetros:
  /// - nome: Nome da praia/trecho
  /// - codigo: Código da estação
  /// - endereco: Localização
  /// - municipio: Município
  /// - coordenadas: LatLng para mapa
  /// - classificacao: Status da água
  EstacaoMonitoramento({
    required this.nome,
    required this.codigo,
    required this.endereco,
    required this.municipio,
    required this.coordenadas,
    required this.classificacao,
  });

  /// VAZIO
  ///
  /// Descrição: Factory constructor para criar estação vazia como fallback.
  /// Parâmetros: nenhum
  /// Retorno: EstacaoMonitoramento com valores padrão
  ///
  /// Usado para evitar erros em operações como firstWhere quando não encontra resultado.
  factory EstacaoMonitoramento.vazio() {
    return EstacaoMonitoramento(
      nome: '',                              // String vazia
      codigo: '',                            // String vazia
      endereco: '',                          // String vazia
      municipio: '',                         // String vazia
      coordenadas: const LatLng(0.0, 0.0),   // Coordenadas zero (Oceano Atlântico)
      classificacao: '',                     // String vazia
    );
  }

  /// FROMJSON
  ///
  /// Descrição: Factory constructor para criar estação a partir de JSON da API.
  /// Parâmetros:
  /// - json: Map com dados da API de balneabilidade
  /// - municipio: Nome do município (passado externamente)
  /// Retorno: EstacaoMonitoramento configurada
  ///
  /// Mapeamento da API:
  /// - 'trecho' → nome e endereco
  /// - 'estacao' → codigo
  /// - 'latitude'/'longitude' → coordenadas
  /// - 'classificacao' → classificacao (padrão: "Próprias")
  factory EstacaoMonitoramento.fromJson(Map<String, dynamic> json, String municipio) {
    return EstacaoMonitoramento(
      nome: json['trecho'] ?? '',            // Nome do trecho da praia
      codigo: json['estacao'] ?? '',         // Código da estação
      endereco: json['trecho'] ?? '',        // Usa mesmo valor do nome
      municipio: municipio,                  // Passado como parâmetro
      coordenadas: LatLng(
        json['latitude']?.toDouble() ?? 0.0,   // Conversão segura para double
        json['longitude']?.toDouble() ?? 0.0, // Conversão segura para double
      ),
      classificacao: json['classificacao'] ?? 'Próprias', // Padrão otimista
    );
  }

  // Fim da classe EstacaoMonitoramento
  // 
  // Modelo de estação de monitoramento com:
  // 
  // 🏖️ DADOS DA PRAIA:
  // - Nome do trecho monitorado
  // - Código identificador único
  // - Endereço/descrição da localização
  // - Município de localização
  // 
  // 🗺️ LOCALIZAÇÃO:
  // - Coordenadas LatLng para Google Maps
  // - Integração com mapas interativos
  // - Posição precisa para marcadores
  // 
  // 💧 QUALIDADE DA ÁGUA:
  // - Classificação: "Próprias" ou "Impróprias"
  // - Status atualizado via API SUDEMA
  // - Informação para segurança dos banhistas
  // 
  // 🔧 CONSTRUTORES:
  // - Construtor padrão com campos obrigatórios
  // - Factory vazio() para fallback
  // - Factory fromJson() para parsing da API
  // - Tratamento de valores nulos
}
