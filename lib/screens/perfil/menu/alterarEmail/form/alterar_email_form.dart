/// ALTERAR_EMAIL_FORM
///
/// Responsável por: Formulário de alteração de e-mail com 3 campos (senha, novo e-mail, confirmar),
/// validações, focus nodes e integração com controller.
/// Utilizado em: Tela de alterar e-mail como formulário principal.

import 'package:flutter/material.dart';
import '../controller/alterar_email_controller.dart';
import '../widgets/alterar_email_widgets.dart';

/// Widget AlterarEmailForm
///
/// Descrição: Formulário com validações, focus management e toggle de senha,
/// usando Form widget para validação integrada.
class AlterarEmailForm extends StatefulWidget {
  const AlterarEmailForm({super.key});

  @override
  State<AlterarEmailForm> createState() => _AlterarEmailFormState();
}

class _AlterarEmailFormState extends State<AlterarEmailForm> {
  // Controllers para gerenciar texto dos campos
  final TextEditingController _senhaController = TextEditingController();          // Senha atual
  final TextEditingController _novoEmailController = TextEditingController();      // Novo e-mail
  final TextEditingController _confirmarEmailController = TextEditingController(); // Confirmação
  
  // Chave global para validação do formulário
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Focus nodes para gerenciar navegação entre campos
  final FocusNode _novoEmailFocus = FocusNode();      // Focus do novo e-mail
  final FocusNode _confirmarEmailFocus = FocusNode(); // Focus da confirmação

  // Estado de visibilidade da senha
  bool _obscureText = true;  // true = oculta, false = visível

  /// DISPOSE
  ///
  /// Descrição: Libera recursos dos controllers e focus nodes quando widget é destruído.
  @override
  void dispose() {
    // Libera controllers
    _senhaController.dispose();
    _novoEmailController.dispose();
    _confirmarEmailController.dispose();
    // Libera focus nodes
    _novoEmailFocus.dispose();
    _confirmarEmailFocus.dispose();
    super.dispose();
  }

  /// BUILD
  ///
  /// Descrição: Constrói formulário com 3 campos, validações e botão de confirmação.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Form com ListView de campos
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,  // Chave para validação do formulário
      child: ListView(
        shrinkWrap: true,                              // Ajusta tamanho ao conteúdo
        physics: const NeverScrollableScrollPhysics(), // Desabilita scroll interno
        children: [
          // Campo 1: Senha atual
          const Text('Senha', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('senhaField'),  // Key para testes
            controller: _senhaController,  // Gerencia texto da senha
            obscureText: _obscureText,     // Controla visibilidade
            decoration: inputDecoration().copyWith(
              // Ícone de toggle personalizado
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,  // Ícone muda com estado
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;  // Alterna visibilidade
                  });
                },
              ),
            ),
            // Validação: campo obrigatório
            validator: (value) =>
                value == null || value.isEmpty ? 'Informe a senha atual' : null,
          ),
          const SizedBox(height: 24),  // Espaçamento entre campos
          
          // Campo 2: Novo e-mail
          const Text('Novo e-mail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('novoEmailField'),  // Key para testes
            controller: _novoEmailController,  // Gerencia texto do novo e-mail
            focusNode: _novoEmailFocus,        // Controle de foco
            keyboardType: TextInputType.text,  // Teclado de texto
            textInputAction: TextInputAction.next,  // Botão "Próximo" no teclado
            autofillHints: const <String>[],   // Sem sugestões de preenchimento
            decoration: inputDecoration(),     // Decoração padrão
            // Validação: campo obrigatório
            validator: (value) =>
                value == null || value.isEmpty ? 'Informe o novo e-mail' : null,
          ),
          const SizedBox(height: 24),
          
          // Campo 3: Confirmação do novo e-mail
          const Text('Confirme o novo e-mail',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            key: const Key('confirmarEmailField'),  // Key para testes
            controller: _confirmarEmailController,  // Gerencia texto da confirmação
            focusNode: _confirmarEmailFocus,        // Controle de foco
            keyboardType: TextInputType.text,       // Teclado de texto
            textInputAction: TextInputAction.done,  // Botão "Concluir" no teclado
            autofillHints: const <String>[],        // Sem sugestões de preenchimento
            decoration: inputDecoration(),          // Decoração padrão
            // Validação: campo obrigatório + coincidência
            validator: (value) {
              if (value == null || value.isEmpty) return 'Confirme o novo e-mail';
              if (value != _novoEmailController.text) return 'Os e-mails não coincidem';
              return null;  // Validação passou
            },
          ),
          const SizedBox(height: 24),  // Espaçamento antes do botão
          
          // Botão de confirmação
          SizedBox(
            width: double.infinity,  // Ocupa toda largura
            child: ElevatedButton(
              key: const Key('submitButton'),  // Key para testes
              onPressed: () {
                // Valida formulário antes de prosseguir
                if (_formKey.currentState!.validate()) {
                  // Chama controller para processar alteração
                  AlterarEmailController.confirmarAlteracao(
                    context: context,
                    senhaAtual: _senhaController.text,
                    novoEmail: _novoEmailController.text,
                    confirmacaoEmail: _confirmarEmailController.text,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B8C00),  // Verde (sucesso)
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),  // Bordas arredondadas
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),  // Padding vertical
                child: Text(
                  'Confirmar alteração de e-mail',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fim da classe AlterarEmailForm
  // 
  // Formulário de alteração de e-mail com:
  // - 3 campos com validações específicas
  // - Toggle de visibilidade para senha
  // - Focus management entre campos
  // - Validação integrada via Form widget
  // - Keys para testes automatizados
  // - Botão de confirmação com estilo verde
}
