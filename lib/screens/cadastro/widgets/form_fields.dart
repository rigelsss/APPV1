/// FORM_FIELDS
///
/// Responsável por: Widgets reutilizáveis para campos de formulário do cadastro,
/// incluindo campos de texto padrão e campos de senha com visibilidade toggle.
/// Utilizado em: Formulário de cadastro para manter consistência visual e funcional.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget CampoTextoPadrao
///
/// Descrição: Campo de texto reutilizável com label, validação de erro,
/// formatadores opcionais e estilo consistente.
class CampoTextoPadrao extends StatelessWidget {
  final String label;                           // Label do campo
  final TextEditingController controller;       // Controller para gerenciar texto
  final TextInputType keyboardType;             // Tipo de teclado (texto, número, email)
  final String hint;                            // Placeholder do campo
  final String? erro;                           // Mensagem de erro (opcional)
  final List<TextInputFormatter>? formatters;   // Formatadores de máscara (opcional)

  const CampoTextoPadrao({
    super.key,
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.hint,
    this.erro,
    this.formatters,
  });

  /// BUILD
  ///
  /// Descrição: Constrói campo de texto com label, input e mensagem de erro opcional.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Padding com estrutura completa do campo
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Espaçamento inferior para separar campos no formulário
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinha elementos à esquerda
        children: [
          // Label do campo com estilo padrão
          Text(label, style: const TextStyle(fontSize: 18)),
          // Campo de entrada principal
          TextField(
            controller: controller,           // Gerencia texto digitado
            keyboardType: keyboardType,       // Define tipo de teclado (texto, número, email)
            inputFormatters: formatters ?? [], // Aplica máscaras se fornecidas
            decoration: InputDecoration(
              hintText: hint,                 // Placeholder do campo
              // Borda quando campo está habilitado mas não focado
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              // Borda quando campo está focado (mais espessa)
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              // Borda quando há erro de validação
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              // Borda quando campo com erro está focado
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
          // Mensagem de erro condicional (só aparece se houver erro)
          if (erro != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0), // Pequeno espaço acima da mensagem
              child: Text(
                erro!,
                style: const TextStyle(color: Colors.red, fontSize: 12), // Texto pequeno e vermelho
              ),
            ),
        ],
      ),
    );
  }

// Fim do arquivo form_fields.dart
// 
// Este arquivo contém widgets reutilizáveis para formulários do app SUDEMA:
// 
// 1. CampoTextoPadrao:
//    - Campo genérico para texto, números, e-mail
//    - Suporte a formatadores de máscara (CPF, telefone)
//    - Validação de erro integrada
//    - Estilo consistente com bordas pretas
// 
// 2. CampoSenha:
//    - Campo especializado para senhas
//    - Toggle de visibilidade (mostrar/ocultar)
//    - Mesmo sistema de validação de erro
//    - Ícone interativo no sufixo
// 
// Ambos os widgets seguem o mesmo padrão visual:
// - Label acima do campo
// - Bordas pretas (normal) ou vermelhas (erro)
// - Mensagem de erro abaixo quando necessário
// - Espaçamento adequado para uso em formulários
}

/// Widget CampoSenha
///
/// Descrição: Campo de senha com funcionalidade de mostrar/ocultar texto,
/// ícone toggle e validação de erro integrada.
class CampoSenha extends StatefulWidget {
  final String label;                    // Label do campo de senha
  final TextEditingController controller; // Controller para gerenciar texto
  final String? erro;                    // Mensagem de erro (opcional)

  const CampoSenha({
    super.key,
    required this.label,
    required this.controller,
    this.erro,
  });

  @override
  State<CampoSenha> createState() => _CampoSenhaState();
}

class _CampoSenhaState extends State<CampoSenha> {
  bool _obscureText = true; // Controla visibilidade da senha (inicia oculta)

  /// BUILD
  ///
  /// Descrição: Constrói campo de senha com toggle de visibilidade e validação de erro.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Padding com estrutura completa do campo de senha
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Espaçamento menor que campos normais (usado em sequência)
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinha elementos à esquerda
        children: [
          // Label do campo de senha
          Text(widget.label, style: const TextStyle(fontSize: 18)),
          // Campo de entrada de senha com funcionalidades especiais
          TextField(
            controller: widget.controller,    // Gerencia texto da senha
            obscureText: _obscureText,        // Controla se senha está oculta
            decoration: InputDecoration(
              // Bordas idênticas ao campo de texto padrão
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              // Ícone de toggle para mostrar/ocultar senha
              suffixIcon: IconButton(
                icon: Icon(
                  // Ícone muda baseado no estado atual
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // Alterna entre mostrar e ocultar senha
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
          // Mensagem de erro condicional (só aparece se houver erro)
          if (widget.erro != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0), // Pequeno espaço acima da mensagem
              child: Text(
                widget.erro!,
                style: const TextStyle(color: Colors.red, fontSize: 12), // Texto pequeno e vermelho
              ),
            ),
        ],
      ),
    );
  }

  // Fim da classe _CampoSenhaState
  // Widget especializado para entrada de senhas com:
  // - Toggle de visibilidade (mostrar/ocultar)
  // - Validação de erro integrada
  // - Estilo consistente com outros campos do formulário
  // - Gerenciamento de estado para controle de visibilidade
}
