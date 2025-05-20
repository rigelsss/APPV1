import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void mostrarErro(BuildContext context, String mensagem) {
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

void mostrarSucesso(BuildContext context, String mensagem) {
  Flushbar(
    title: 'Sucesso',
    message: mensagem,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green.shade600,
    icon: const Icon(Icons.check_circle, color: Colors.white),
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.circular(10),
    margin: const EdgeInsets.all(8),
  ).show(context);
}
