import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sudema_app/screens/home/home_screen.dart';
import 'package:sudema_app/screens/diversos/reativar_conta.dart';
import 'package:sudema_app/screens/cadastro/confirmar_cadastro.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudema_app/services/controllerLogin.dart';
import 'package:sudema_app/services/AuthMe.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreenController {
  Future<void> _obterESalvarDeviceToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('deviceToken', fcmToken);
        print('Device Token salvo no SharedPreferences: $fcmToken');
      } else {
        print('Não foi possível obter o deviceToken do Firebase Messaging');
      }
    } catch (e) {
      print('Erro ao obter deviceToken: $e');
    }
  }

  Future<Map<String, dynamic>?> obterInformacoesUsuario(
    BuildContext context,
    String token,
  ) async {
    try {
      final data = await AuthController.obterInformacoesUsuario(token);
      if (data != null) {
        print('Dados do usuário: $data');
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao buscar dados do usuário')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter informações do usuário: $e')),
      );
      return null;
    }
  }

  Future<void> realizarLogin({
    required BuildContext context,
    required String email,
    required String senha,
    required Function(String) onTokenReceived,
    required Function(Map<String, dynamic>) onUserDataReceived,
    String? voltarPara,
  }) async {
    if (email.isEmpty || senha.isEmpty) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageText: Text('preencha todos os campos',
          style: TextStyle(color: Colors.red, fontSize: 16),),
      duration: Duration(seconds: 3),
      backgroundColor: Color(0xFFF8DFDD),
        icon: SvgPicture.asset(
          'assets/icon/x-circle.svg',
          width: 28,
          height: 28,
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
      ).show(context);
      return;
    }

    try {
      final resultado = await LoginController.realizarLogin(email, senha);

      if (resultado['success']) {
        final token = resultado['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        onTokenReceived(token);
        await _obterESalvarDeviceToken();

        final dadosUsuario = await obterInformacoesUsuario(context, token);
        if (dadosUsuario != null) {
          onUserDataReceived(dadosUsuario);

          if (voltarPara != null) {
            Navigator.pushReplacementNamed(context, voltarPara);
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
        Flushbar(flushbarPosition: FlushbarPosition.TOP,
          messageText: Text('E-mail ou senha inválidos. Verifique suas credenciais.',
          style: TextStyle(color: Colors.red, fontSize: 16),),
          duration: const Duration(seconds: 3),
          backgroundColor: Color(0xFFF8DFDD),
          icon: SvgPicture.asset('assets/icon/x-circle.svg',
          width: 28, height: 28, color: Colors.red,),
          borderRadius: BorderRadius.circular(10),
          margin: const EdgeInsets.all(8),
        ).show(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao realizar login: $e')),
      );
    }
  }
}
