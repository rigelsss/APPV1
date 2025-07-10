import 'package:sudema_app/utils/validarCPF.dart';


String? validarNome(String? value) {
  if (value == null || value.trim().split(' ').length < 2) {
    return 'Digite seu nome completo.';
  }
  return null;
}

String? validarTelefone(String? value) {
  final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
  if (digits.length != 11) {
    return 'Telefone inválido.';
  }
  return null;
}

String? validarCpf(String? value) {
  if (value == null || !validarCPF(value)) {
    return 'CPF inválido.';
  }
  return null;
}