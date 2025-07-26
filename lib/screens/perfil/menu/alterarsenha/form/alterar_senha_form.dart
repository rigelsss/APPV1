/// ALTERAR_SENHA_FORM
///
/// Responsável por: Formulário de alteração de senha com 3 campos (atual, nova, confirmar),
/// validações, feedback visual e link para recuperação de senha.
/// Utilizado em: Tela de alterar senha como formulário principal.

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sudema_app/screens/perfil/menu/alterarsenha/controller/alterar_senha_controller.dart';
import 'package:sudema_app/screens/senhas/RecuperacaoSenha.dart';
import '../widgets/alterar_senha_widget_decoration.dart'; 

/// Widget AlterarSenhaForm
///
/// Descrição: Formulário com 3 campos de senha, toggle de visibilidade,
/// validações e feedback via Flushbar.
class AlterarSenhaForm extends StatefulWidget {
  const AlterarSenhaForm({super.key});

  @override
  State<AlterarSenhaForm> createState() => _AlterarSenhaFormState();
}

class _AlterarSenhaFormState extends State<AlterarSenhaForm> {
  // Controllers para gerenciar texto dos campos
  final TextEditingController _senhaAtualController = TextEditingController();    // Senha atual
  final TextEditingController _novaSenhaController = TextEditingController();     // Nova senha
  final TextEditingController _confirmarSenhaController = TextEditingController(); // Confirmação

  // Estados de visibilidade das senhas (true = oculta, false = visível)
  bool _obscureCurrent = true;  // Visibilidade da senha atual
  bool _obscureNew = true;      // Visibilidade da nova senha
  bool _obscureConfirm = true;  // Visibilidade da confirmação

  /// DISPOSE
  ///
  /// Descrição: Libera recursos dos controllers quando widget é destruído.
  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  /// _CONFIRMARALTERACAO
  ///
  /// Descrição: Processa alteração de senha com validações e feedback visual.
  /// Parâmetros: nenhum (usa controllers internos)
  /// Retorno: Future<void>
  ///
  /// Fluxo: validações locais → chamada controller → feedback → navegação
  void _confirmarAlteracao() async {
    // Validação 1: Todos os campos devem estar preenchidos
    if (_senhaAtualController.text.trim().isEmpty ||
        _novaSenhaController.text.trim().isEmpty ||
        _confirmarSenhaController.text.trim().isEmpty) {
      // Exibe erro via Flushbar
      await Flushbar(
        message: 'Por favor, preencha todos os campos',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
      return; // Interrompe execução
    }

    // Validação 2: Nova senha e confirmação devem coincidir
    if (_novaSenhaController.text.trim() != _confirmarSenhaController.text.trim()) {
      // Exibe erro via Flushbar
      await Flushbar(
        message: 'As senhas novas não coincidem',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
      return; // Interrompe execução
    }

    // Chama controller para processar alteração via API
    final mensagem = await AlterarSenhaController.alterarSenha(
      senhaAtual: _senhaAtualController.text.trim(),
      novaSenha: _novaSenhaController.text.trim(),
      confirmarSenha: _confirmarSenhaController.text.trim(),
    );

    // Processa resultado da operação
    if (mensagem == null) {
      // Sucesso: exibe feedback positivo
      await Flushbar(
        message: 'Senha alterada com sucesso!',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,           // Fundo verde
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ).show(context);
      // Navega para home substituindo tela atual
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Erro: exibe mensagem de erro específica
      await Flushbar(
        message: mensagem,                       // Mensagem do controller
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,            // Fundo vermelho
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
    }
  }

  /// BUILD
  ///
  /// Descrição: Constrói formulário com 3 campos de senha, botão de confirmação e link de recuperação.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Column com estrutura completa do formulário
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinha elementos à esquerda
      children: [
        // Campo 1: Senha atual
        const Text('Senha atual', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _senhaAtualController,  // Gerencia texto da senha atual
          obscureText: _obscureCurrent,       // Controla visibilidade
          decoration: inputDecoration(
            obscure: _obscureCurrent,         // Estado atual de visibilidade
            onToggle: () {
              setState(() {
                _obscureCurrent = !_obscureCurrent;  // Alterna visibilidade
              });
            },
          ),
        ),
        const SizedBox(height: 24),  // Espaçamento entre campos
        
        // Campo 2: Nova senha
        const Text('Nova senha', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _novaSenhaController,   // Gerencia texto da nova senha
          obscureText: _obscureNew,           // Controla visibilidade
          decoration: inputDecoration(
            obscure: _obscureNew,             // Estado atual de visibilidade
            onToggle: () {
              setState(() {
                _obscureNew = !_obscureNew;     // Alterna visibilidade
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dica sobre critérios de senha segura
        const Text(
          'A senha deve ter no mínimo 8 caracteres e deve conter letras, números e caracteres especiais',
          style: TextStyle(color: Color(0xFF747474)),  // Texto cinza para dica
        ),
        const SizedBox(height: 24),
        
        // Campo 3: Confirmação da nova senha
        const Text('Confirme a nova senha', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: _confirmarSenhaController,  // Gerencia texto da confirmação
          obscureText: _obscureConfirm,           // Controla visibilidade
          decoration: inputDecoration(
            obscure: _obscureConfirm,             // Estado atual de visibilidade
            onToggle: () {
              setState(() {
                _obscureConfirm = !_obscureConfirm; // Alterna visibilidade
              });
            },
          ),
        ),
        const SizedBox(height: 20),  // Espaçamento antes do botão
        
        // Botão principal de confirmação
        SizedBox(
          width: double.infinity,  // Ocupa toda largura disponível
          child: ElevatedButton(
            onPressed: _confirmarAlteracao,  // Chama método de confirmação
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B8C00),  // Verde (cor de sucesso)
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),  // Bordas bem arredondadas
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),  // Padding vertical generoso
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícone do botão (logout icon reutilizado)
                  Icon(Icons.logout, color: Colors.white),
                  SizedBox(width: 8),  // Espaço entre ícone e texto
                  // Texto do botão
                  Text(
                    'Confirmar alteração de senha',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),  // Espaçamento antes do link
        
        // Link para recuperação de senha (caso usuário esqueça senha atual)
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                // Texto normal
                const TextSpan(
                  text: 'Esqueceu a senha atual? ',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                // Link clicável
                TextSpan(
                  text: ' Recuperar',
                  style: const TextStyle(
                      color: Color(0xFF2A2F8C),     // Azul SUDEMA
                      fontSize: 16,
                      fontWeight: FontWeight.bold   // Destaque em negrito
                  ),
                  // Reconhecedor de toque para navegação
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navega para tela de recuperação de senha
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecuperacaoSenha(),
                        ),
                      );
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Fim da classe AlterarSenhaForm
  // 
  // Formulário completo de alteração de senha com:
  // - 3 campos com toggle de visibilidade independente
  // - Validações locais (campos preenchidos, senhas coincidem)
  // - Integração com controller para processamento via API
  // - Feedback visual via Flushbar (sucesso/erro)
  // - Dica de critérios de senha segura
  // - Botão de confirmação com estilo verde
  // - Link para recuperação de senha como alternativa
  // - Navegação para home após sucesso
}
