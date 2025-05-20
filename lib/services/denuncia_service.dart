// denuncia_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import '../screens/widgets/custom_snackbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DenunciaService {
  static Future<bool> enviar(BuildContext context, DenunciaData data) async {
    // 🔎 Validações iniciais
    if (data.tipoDenunciaId == null || int.tryParse(data.tipoDenunciaId!) == null) {
      CustomSnackbar.erro(context, 'Categoria da denúncia não foi selecionada corretamente.');
      return false;
    }

    if (data.usuarioId == null || data.usuarioId!.isEmpty) {
      CustomSnackbar.erro(context, 'Usuário não identificado. Faça login novamente.');
      return false;
    }

    if ([data.estado, data.bairro, data.municipio, data.logradouro].any((e) => e == null || e.isEmpty)) {
      CustomSnackbar.erro(context, 'Preencha todos os dados do endereço antes de enviar.');
      return false;
    }

    // 📆 Validação da data
    try {
      final format = DateFormat('dd/MM/yyyy');
      final parsedDate = format.parseStrict(data.dataOcorrencia ?? '');
      data.dataOcorrencia = parsedDate.toIso8601String();
    } catch (e) {
      CustomSnackbar.erro(context, 'Data inválida. Use o formato dd/mm/aaaa');
      return false;
    }

    // 🌐 Preparando a requisição
    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      CustomSnackbar.erro(context, 'URL da API não configurada.');
      return false;
    }

    final url = Uri.parse('$baseUrl/denuncias');
    final request = http.MultipartRequest('POST', url);

    if (data.tokenUsuario != null) {
      request.headers['Authorization'] = 'Bearer ${data.tokenUsuario}';
    } else {
      CustomSnackbar.erro(context, 'Token do usuário ausente.');
      return false;
    }

    // 🧾 Corpo da denúncia e endereço
    final denunciaJson = jsonEncode({
      "tipoDenunciaId": data.tipoDenunciaId,
      "usuarioId": data.usuarioId,
      "descricao": data.descricao,
      "informacaoDenunciado": data.informacaoDenunciado,
      "dataOcorrido": data.dataOcorrencia,
      "anonimo": data.anonimo ?? false,
    });

    final enderecoJson = jsonEncode({
      "longitude": data.longitude,
      "latitude": data.latitude,
      "estado": data.estado,
      "bairro": data.bairro,
      "municipio": data.municipio,
      "logradouro": data.logradouro,
      "pontoReferencia": data.referencia,
    });

    request.files.add(http.MultipartFile.fromString(
      'denuncia',
      denunciaJson,
      contentType: MediaType('application', 'json'),
    ));

    request.files.add(http.MultipartFile.fromString(
      'endereco',
      enderecoJson,
      contentType: MediaType('application', 'json'),
    ));

    // 🖼️ Anexo da imagem (se houver)
    if (data.imagemPath != null && File(data.imagemPath!).existsSync()) {
      try {
        final file = File(data.imagemPath!);
        final extension = file.path.split('.').last.toLowerCase();
        final mediaType = extension == 'png' ? 'png' : 'jpeg';

        request.files.add(await http.MultipartFile.fromPath(
          'anexos',
          file.path,
          filename: file.path.split('/').last,
          contentType: MediaType('image', mediaType),
        ));
      } catch (e) {
        debugPrint('⚠️ Erro ao adicionar imagem: $e');
        CustomSnackbar.erro(context, 'Erro ao processar imagem. Tente outra.');
        return false;
      }
    }

    // 📡 Enviando a requisição
    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      switch (response.statusCode) {
        case 200:
        case 201:
          debugPrint('✅ Denúncia enviada com sucesso.');
          return true;
        case 400:
          CustomSnackbar.erro(context, 'Requisição inválida. Verifique os campos preenchidos.');
          break;
        case 401:
          CustomSnackbar.erro(context, 'Não autorizado. Refaça o login.');
          break;
        case 403:
          CustomSnackbar.erro(context, 'Acesso negado.');
          break;
        case 500:
          CustomSnackbar.erro(context, 'Erro interno do servidor. Tente novamente mais tarde.');
          break;
        default:
          debugPrint('⚠️ Código de resposta inesperado: ${response.statusCode}');
          CustomSnackbar.erro(context, 'Erro ${response.statusCode}: $body');
      }
    } catch (e, stack) {
      debugPrint('❌ Exceção no envio da denúncia: $e');
      debugPrint('📌 Stack trace:\n$stack');

      if (e is SocketException) {
        CustomSnackbar.erro(context, 'Sem conexão com a internet.');
      } else {
        CustomSnackbar.erro(context, 'Erro inesperado: ${e.toString()}');
      }
    }

    return false;
  }
}
