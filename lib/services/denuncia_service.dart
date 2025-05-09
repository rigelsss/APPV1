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
    // Validações iniciais
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

    // Converte data para ISO 8601
    try {
      final format = DateFormat('dd/MM/yyyy');
      final parsedDate = format.parse(data.dataOcorrencia ?? '');
      data.dataOcorrencia = parsedDate.toIso8601String();
    } catch (e) {
      CustomSnackbar.erro(context, 'Data inválida. Use o formato dd/mm/aaaa');
      return false;
    }

    // Carrega URL base do .env
    final baseUrl = dotenv.env['URL_API'];
    final url = Uri.parse('$baseUrl/denuncias');

    final request = http.MultipartRequest('POST', url);

    if (data.tokenUsuario != null) {
      request.headers['Authorization'] = 'Bearer ${data.tokenUsuario}';
    }

    final denunciaJson = jsonEncode({
      "tipoDenunciaId": int.parse(data.tipoDenunciaId!),
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

    if (data.imagemPath != null && File(data.imagemPath!).existsSync()) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'anexos',
          data.imagemPath!,
          filename: data.imagemPath!.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        CustomSnackbar.erro(context, 'Erro ao enviar denúncia (${response.statusCode}): $body');
        return false;
      }
    } catch (e) {
      CustomSnackbar.erro(context, 'Erro na requisição: $e');
      return false;
    }
  }
}
