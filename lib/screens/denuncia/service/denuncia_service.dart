/// DENUNCIA_SERVICE
///
/// Responsável por: Envio de denúncias ambientais para a API da SUDEMA.
/// Utilizado em: Etapa final do fluxo de denúncias, após preenchimento completo.
/// 
/// Este service gerencia:
/// - Validação completa dos dados da denúncia
/// - Envio multipart com texto e imagens
/// - Tratamento de erros específicos da API
/// - Feedback visual para o usuário
/// - Suporte a denúncias anônimas e identificadas

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import '../../widgets/custom_snackbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DenunciaService {
  /// Integração com a API de denúncias
  ///
  /// Envia denúncia completa para o endpoint:
  /// POST /denuncias
  ///
  /// Suporta envio multipart com dados JSON e imagens.
  /// Requer autenticação JWT para denúncias identificadas.
  static Future<bool> enviar(BuildContext context, DenunciaData data) async {
    // Validação 1: Categoria da denúncia
    if (data.tipoDenunciaId == null || int.tryParse(data.tipoDenunciaId!) == null) {
      CustomSnackbar.erro(context, 'Categoria da denúncia não foi selecionada corretamente.');
      return false;
    }

    // Validação 2: Identificação do usuário
    if (data.usuarioId == null || data.usuarioId!.isEmpty) {
      CustomSnackbar.erro(context, 'Usuário não identificado. Faça login novamente.');
      return false;
    }

    // Validação 3: Dados de endereço obrigatórios
    if ([data.estado, data.bairro, data.municipio, data.logradouro].any((e) => e == null || e.isEmpty)) {
      CustomSnackbar.erro(context, 'Preencha todos os dados do endereço antes de enviar.');
      return false;
    }

    // Validação 4: Formato da data de ocorrência
    try {
      final format = DateFormat('dd/MM/yyyy');
      final parsedDate = format.parseStrict(data.dataOcorrencia ?? '');
      // Converte para formato ISO para a API
      data.dataOcorrencia = parsedDate.toIso8601String();
    } catch (e) {
      CustomSnackbar.erro(context, 'Data inválida. Use o formato dd/mm/aaaa');
      return false;
    }

    // Preparação da requisição multipart para a API SUDEMA
    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      CustomSnackbar.erro(context, 'URL da API não configurada.');
      return false;
    }

    final url = Uri.parse('$baseUrl/denuncias');
    final request = http.MultipartRequest('POST', url);

    // Adiciona token JWT para autenticação
    if (data.tokenUsuario != null) {
      request.headers['Authorization'] = 'Bearer ${data.tokenUsuario}';
    } else {
      CustomSnackbar.erro(context, 'Token do usuário ausente.');
      return false;
    }

    // Construção dos dados da denúncia em formato JSON
    final denunciaJson = jsonEncode({
      "tipoDenunciaId": data.tipoDenunciaId,           // ID da categoria selecionada
      "usuarioId": data.usuarioId,                     // ID do usuário (mesmo para anônimas)
      "descricao": data.descricao,                     // Descrição da infração
      "informacaoDenunciado": data.informacaoDenunciado, // Dados do infrator (opcional)
      "dataOcorrido": data.dataOcorrencia,             // Data da ocorrência (ISO format)
      "anonimo": data.anonimo ?? false,                // Flag para denúncia anônima
    });

    // Construção dos dados de localização em formato JSON
    final enderecoJson = jsonEncode({
      "longitude": data.longitude,        // Coordenada GPS
      "latitude": data.latitude,          // Coordenada GPS
      "estado": data.estado,              // Estado (Paraíba)
      "bairro": data.bairro,              // Bairro da ocorrência
      "municipio": data.municipio,        // Município da ocorrência
      "logradouro": data.logradouro,      // Rua/Avenida
      "pontoReferencia": data.referencia, // Ponto de referência (opcional)
    });

    // Adiciona dados da denúncia como parte multipart
    request.files.add(http.MultipartFile.fromString(
      'denuncia',
      denunciaJson,
      contentType: MediaType('application', 'json'),
    ));

    // Adiciona dados do endereço como parte multipart
    request.files.add(http.MultipartFile.fromString(
      'endereco',
      enderecoJson,
      contentType: MediaType('application', 'json'),
    ));

    // Processamento e anexo de imagens (opcional)
    if (data.imagemPaths.isNotEmpty) {
      for (final path in data.imagemPaths) {
      final file = File(path);
    
      if (file.existsSync()) {
        try {
          // Determina o tipo de imagem baseado na extensão
          final extension = file.path.split('.').last.toLowerCase();
          final mediaType = extension == 'png' ? 'png' : 'jpeg';

          // Adiciona imagem como anexo multipart
          request.files.add(await http.MultipartFile.fromPath(
            'anexos',
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType('image', mediaType),
          ));
        } catch (e) {
          debugPrint('Erro ao adicionar imagem $path: $e');
          CustomSnackbar.erro(context, 'Erro ao processar imagem: ${file.path}');
          return false;
        }
      }
    }
  }
    // Envio da requisição para a API SUDEMA
    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      // Tratamento dos códigos de resposta da API
      switch (response.statusCode) {
        case 200:
        case 201:
          debugPrint('Denúncia enviada com sucesso.');
          return true; // Sucesso no envio
        case 400:
          CustomSnackbar.erro(context, 'Requisição inválida. Verifique os campos preenchidos.');
          break;
        case 401:
          CustomSnackbar.erro(context, 'Não autorizado. Refaça o login.');
          break;
        case 403:
          CustomSnackbar.erro(context, 'Acesso negado.');
          break;
        case 429:
          // Limite de denúncias por dia atingido
          CustomSnackbar.erro(context, 'Você atingiu o limite de denúncias permitido por dia.');
          break;
        case 500:
          CustomSnackbar.erro(context, 'Erro interno do servidor. Tente novamente mais tarde.');
          break;
        default:
          debugPrint('Código de resposta inesperado: ${response.statusCode}');
          CustomSnackbar.erro(context, 'Erro ${response.statusCode}: $body');
      }
    } catch (e, stack) {
      // Tratamento de exceções durante o envio
      debugPrint('Exceção no envio da denúncia: $e');
      debugPrint('Stack trace:\n$stack');

      if (e is SocketException) {
        // Erro de conexão com a internet
        CustomSnackbar.erro(context, 'Sem conexão com a internet.');
      } else {
        // Outros erros inesperados
        CustomSnackbar.erro(context, 'Erro inesperado: ${e.toString()}');
      }
    }

    return false;
  }
}
