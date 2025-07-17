import 'package:flutter/material.dart';
import 'package:sudema_app/services/controllerLogin.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:sudema_app/screens/home/home_screen.dart';
import 'package:sudema_app/screens/registerUser/confirmarRegistro.dart';
import 'package:sudema_app/screens/reativar_conta.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:another_flushbar/flushbar.dart';

import 'login_prefs_service.dart';

class LoginService {
  static Future<void> realizarLogin({
    required BuildContext context,
    required String email,
    required String senha,
    required bool manterConectado,
    String? redirecionarPara,
    required Function(String token) onTokenReceived,
  }) async {
    if (email.isEmpty || senha.isEmpty) {
      _mostrarFlushbar(
        context,
        'Preencha todos os campos obrigatórios para realizar o login.',
      );
      return;
    }
    try {
      final resultado = await LoginController.realizarLogin(email, senha);

      if (resultado['success']) {
        final token = resultado['data']['token'];
        onTokenReceived(token);

        if (manterConectado) {
          await LoginPrefsService.setKeepLoggedIn(true);
          await LoginPrefsService.saveToken(token);
        }

        await _obterESalvarDeviceToken();

        final dadosUsuario = await AuthController.obterInformacoesUsuario(token);

        if (dadosUsuario != null) {
          if (redirecionarPara != null) {
            Navigator.pushReplacementNamed(context, redirecionarPara);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  initialIndex: 0,
                  userInfo: dadosUsuario,
                ),
              ),
            );
          }
        } else {
          _mostrarSnackBar(context, 'Erro ao buscar dados do usuário');
        }
      } else if (resultado['disabledUser'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReativarContaPage(email: email, senha: senha),
          ),
        );
      } else if (resultado['nonVerifiedUser'] == true || resultado['statusCode'] == 423) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CodigoRegistro(email: resultado['email']),
          ),
        );
      } else {
        final mensagem = resultado['message'];
        if (mensagem != null && mensagem.toString().isNotEmpty) {
          _mostrarFlushbar(context, mensagem.toString());
        } else {
          _mostrarFlushbar(
              context, 'E-mail ou senha inválidos. Verifique suas credenciais.');
        }
      }
    } catch (e) {
      _mostrarSnackBar(context, 'Erro ao realizar login: $e');
    }
  }


  static Future<void> _obterESalvarDeviceToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await LoginPrefsService.saveToken(fcmToken); 
        print('Device Token salvo: $fcmToken');
      } else {
        print('Não foi possível obter o deviceToken');
      }
    } catch (e) {
      print('Erro ao obter deviceToken: $e');
    }
  }

  static void _mostrarSnackBar(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  static void _mostrarFlushbar(BuildContext context, String mensagem) {
    Flushbar(
      title: 'Erro',
      message: mensagem,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red.shade600,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(10),
      margin: const EdgeInsets.all(8),
    ).show(context);
  }
}
