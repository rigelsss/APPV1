import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/services/AuthMe.dart';

class PerfilController extends ChangeNotifier {
  Map<String, dynamic> userData = {};
  bool isLoading = true;
  bool errorFetching = false;
  String errorMessage = '';
  late String token;

  Future<void> prepararToken({String? tokenExterno}) async {
    if (tokenExterno != null && tokenExterno.isNotEmpty) {
      token = tokenExterno;
      await carregarDadosUsuario();
    } else {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('token');

      if (savedToken != null && savedToken.isNotEmpty) {
        token = savedToken;
        await carregarDadosUsuario();
      } else {
        errorFetching = true;
        isLoading = false;
        errorMessage = 'Token inválido ou não fornecido.';
        notifyListeners();
      }
    }
  }

  Future<void> carregarDadosUsuario() async {
    try {
      final data = await AuthController.obterInformacoesUsuario(token);

      if (data != null) {
        userData = data;
        isLoading = false;
        notifyListeners();
      } else {
        errorFetching = true;
        isLoading = false;
        errorMessage = 'Informações do usuário não encontradas.';
        notifyListeners();
      }
    } catch (e) {
      errorFetching = true;
      isLoading = false;
      errorMessage = 'Erro ao buscar dados: $e';
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}