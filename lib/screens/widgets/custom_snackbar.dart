import 'package:flutter/material.dart';

class CustomSnackbar {
  static void erro(BuildContext context, String mensagem) {
    _mostrar(context, mensagem, Colors.red);
  }

  static void sucesso(BuildContext context, String mensagem) {
    _mostrar(context, mensagem, Colors.green);
  }

  static void _mostrar(BuildContext context, String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
