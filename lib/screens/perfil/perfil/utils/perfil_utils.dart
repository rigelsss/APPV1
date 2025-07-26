/// PERFIL_UTILS
///
/// Responsável por: Funções utilitárias para formatar dados do usuário
/// (CPF e telefone) com máscaras brasileiras padrão.
/// Utilizado em: PerfilInfoCard para exibir dados formatados.

/// FORMATARCPF
///
/// Descrição: Formata string de CPF com máscara XXX.XXX.XXX-XX.
/// Parâmetros:
/// - cpf: String com CPF (com ou sem formatação)
/// Retorno: String formatada ou original se inválida
///
/// Exemplo: "12345678901" → "123.456.789-01"
String formatarCpf(String cpf) {
  // Remove todos os caracteres não numéricos
  final digitsOnly = cpf.replaceAll(RegExp(r'\D'), '');
  
  // Valida se tem exatamente 11 dígitos
  if (digitsOnly.length != 11) return cpf;  // Retorna original se inválido
  
  // Aplica máscara XXX.XXX.XXX-XX
  return '${digitsOnly.substring(0, 3)}.${digitsOnly.substring(3, 6)}.${digitsOnly.substring(6, 9)}-${digitsOnly.substring(9)}';
}

/// FORMATARTELEFONE
///
/// Descrição: Formata string de telefone brasileiro com código do país e máscara.
/// Parâmetros:
/// - telefone: String com telefone (com ou sem formatação)
/// Retorno: String formatada ou original se inválida
///
/// Exemplos:
/// - "11987654321" (11 dígitos) → "+55 (11) 98765-4321" (celular)
/// - "1134567890" (10 dígitos) → "+55 (11) 3456-7890" (fixo)
String formatarTelefone(String telefone) {
  // Remove todos os caracteres não numéricos
  final digitsOnly = telefone.replaceAll(RegExp(r'\D'), '');
  
  if (digitsOnly.length == 11) {
    // Celular: +55 (XX) XXXXX-XXXX
    return '+55 (${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 7)}-${digitsOnly.substring(7)}';
  } else if (digitsOnly.length == 10) {
    // Fixo: +55 (XX) XXXX-XXXX
    return '+55 (${digitsOnly.substring(0, 2)}) ${digitsOnly.substring(2, 6)}-${digitsOnly.substring(6)}';
  }
  
  // Retorna original se não tem 10 ou 11 dígitos
  return telefone;
}

// Fim do arquivo perfil_utils.dart
// 
// Funções utilitárias para formatar:
// - CPF: Máscara XXX.XXX.XXX-XX (11 dígitos)
// - Telefone: Máscaras brasileiras com +55
//   - Celular: +55 (XX) XXXXX-XXXX (11 dígitos)
//   - Fixo: +55 (XX) XXXX-XXXX (10 dígitos)
// - Validação de comprimento antes da formatação
// - Retorno seguro (original se inválido)
