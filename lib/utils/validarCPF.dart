bool validarCPF(String cpf) {
  final numericCpf = cpf.replaceAll(RegExp(r'\D'), '');
  if (numericCpf.length != 11 || RegExp(r'^(\d)\1{10}$').hasMatch(numericCpf)) return false;

  List<int> digits = numericCpf.split('').map(int.parse).toList();
  for (int j = 9; j < 11; j++) {
    int sum = 0;
    for (int i = 0; i < j; i++) {
      sum += digits[i] * ((j + 1) - i);
    }
    int expectedDigit = (sum * 10) % 11;
    if (expectedDigit == 10) expectedDigit = 0;
    if (digits[j] != expectedDigit) return false;
  }
  return true;
}
