/// ALTERAR_PERFIL_VALIDADORES
///
/// Responsável por: Funções de validação para campos do formulário de edição
/// de perfil (nome, telefone, CPF) com regras específicas.
/// Utilizado em: EditarPerfilForm para validar entrada do usuário.

import 'package:sudema_app/utils/validarCPF.dart';

/// VALIDARNOME
///
/// Descrição: Valida se nome contém pelo menos 2 palavras (nome e sobrenome).
/// Parâmetros:
/// - value: Valor do campo de nome
/// Retorno: String? - null se válido, mensagem de erro se inválido
///
/// Regra: Deve ter pelo menos 2 palavras separadas por espaço.
String? validarNome(String? value) {
  // Verifica se valor existe e tem pelo menos 2 palavras
  if (value == null || value.trim().split(' ').length < 2) {
    return 'Digite seu nome completo.';
  }
  return null;  // Válido
}

/// VALIDARTELEFONE
///
/// Descrição: Valida se telefone tem exatamente 11 dígitos (formato celular brasileiro).
/// Parâmetros:
/// - value: Valor do campo de telefone (pode conter máscara)
/// Retorno: String? - null se válido, mensagem de erro se inválido
///
/// Regra: Exatamente 11 dígitos (XX9XXXX-XXXX).
String? validarTelefone(String? value) {
  // Remove todos os caracteres não numéricos
  final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
  
  // Valida se tem exatamente 11 dígitos
  if (digits.length != 11) {
    return 'Telefone inválido.';
  }
  return null;  // Válido
}

/// VALIDARCPF
///
/// Descrição: Valida CPF usando algoritmo de verificação de dígitos.
/// Parâmetros:
/// - value: Valor do campo de CPF (pode conter máscara)
/// Retorno: String? - null se válido, mensagem de erro se inválido
///
/// Usa função utilitária validarCPF que implementa algoritmo oficial.
String? validarCpf(String? value) {
  // Usa função utilitária que implementa algoritmo de CPF
  if (value == null || !validarCPF(value)) {
    return 'CPF inválido.';
  }
  return null;  // Válido
}

// Fim do arquivo alterar_perfil_validadores.dart
// 
// Funções de validação para edição de perfil:
// 
// 1. validarNome():
//    - Exige pelo menos 2 palavras
//    - Trim automático para remover espaços extras
//    - Validação de nome completo
// 
// 2. validarTelefone():
//    - Remove máscara automaticamente
//    - Valida exatamente 11 dígitos
//    - Formato celular brasileiro
// 
// 3. validarCpf():
//    - Integração com utilitário de CPF
//    - Algoritmo oficial de verificação
//    - Aceita CPF com ou sem máscara