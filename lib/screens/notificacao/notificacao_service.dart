import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sudema_app/services/AuthMe.dart';


class NotificacoesService {
  static Future<void> solicitarPermissaoNotificacoes() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<bool> ativarNotificacoesPush(bool ativar) async {
    final token = await AuthController.getToken();
    if (token == null) return false;

    final user = await AuthController.obterInformacoesUsuario(token);
    if (user == null || user['id'] == null) return false;

    final userId = user['id'].toString();

    if (ativar) {
      final deviceToken = await FirebaseMessaging.instance.getToken();
      if (deviceToken == null) return false;

      final url = Uri.parse('${dotenv.env['URL_API']}/usuarios/mobile/$userId/notificacoes/ativar');
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'deviceToken': deviceToken}),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    }

    return true;
  }

  static Future<List<dynamic>?> carregarNotificacoes() async {
    final token = await AuthController.getToken();
    if (token == null) return null;

    final user = await AuthController.obterInformacoesUsuario(token);
    if (user == null || user['id'] == null) return null;

    final userId = user['id'];
    final response = await http.get(
      Uri.parse('${dotenv.env['URL_API']}/usuarios/mobile/$userId/notificacoes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = utf8.decode(response.bodyBytes);
      final decoded = json.decode(body);
      return decoded['notificacoes'] ?? [];
    }

    return null;
  }

  static Future<void> marcarComoLida(String notificacaoId, int index, List<dynamic> lista, Function atualizar) async {
    final token = await AuthController.getToken();
    if (token == null) return;

    final user = await AuthController.obterInformacoesUsuario(token);
    if (user == null || user['id'] == null) return;

    final userId = user['id'].toString();

    final url = Uri.parse('${dotenv.env['URL_API']}/usuarios/mobile/$userId/notificacoes/$notificacaoId/marcar-como-lida');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      lista[index]['isRead'] = true;
      atualizar();
    }
  }
}
