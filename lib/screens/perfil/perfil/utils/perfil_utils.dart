String formatarCpf(String cpf) {
  final digitsOnly = cpf.replaceAll(RegExp(r'\D'), '');
  if (digitsOnly.length != 11) return cpf;
  return '${digitsOnly.substring(0, 3)}.${digitsOnly.substring(3, 6)}.${digitsOnly.substring(6, 9)}-${digitsOnly.substring(9)}';
}


String formatarTelefone(String telefone) {
  final digitsOnly = telefone.replaceAll(RegExp(r'\D'), '');
  if (digitsOnly.length == 11) {
    return '+55 (${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 7)}-${digitsOnly.substring(7)}';
  } else if (digitsOnly.length == 10) {
    return '+55 (${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 6)}-${digitsOnly.substring(6)}';
  }
  return telefone;
}
