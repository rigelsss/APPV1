/// CONFIRMAR_CADASTRO
///
/// Responsável por: Tela de confirmação de cadastro via código de 6 dígitos enviado por e-mail.
/// Utilizado em: Após cadastro inicial, para validar e ativar a conta do usuário no sistema SUDEMA.

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sudema_app/screens/login/login.dart';
import 'package:sudema_app/screens/cadastro/service/confirmar_cadastro_service.dart';
import 'package:another_flushbar/flushbar.dart';

/// Widget CodigoRegistro
///
/// Descrição: Tela de verificação com campo PIN de 6 dígitos, botões de confirmação
/// e reenvio de código, com layout responsivo e feedback visual.
class CodigoRegistro extends StatefulWidget {
  final String email; // E-mail do usuário para confirmação
  const CodigoRegistro({super.key, required this.email});

  @override
  State<CodigoRegistro> createState() => _CodigoRegistroState();
}

class _CodigoRegistroState extends State<CodigoRegistro> {
  String _token = '';                          // Código de 6 dígitos digitado pelo usuário
  bool _isLoading = false;                     // Estado de carregamento para desabilitar botões
  final _service = ConfirmarCadastroService(); // Service para comunicação com API

  /// _MOSTRARERROFLUSHBAR
  ///
  /// Descrição: Exibe notificação de erro no topo da tela com ícone e estilo vermelho.
  /// Parâmetros:
  /// - mensagem: Texto do erro a ser exibido
  /// Retorno: void
  void _mostrarErroFlushbar(String mensagem) {
    Flushbar(
      duration: const Duration(seconds: 4),
      backgroundColor: const Color(0xFFF8DFDD), // Fundo vermelho claro
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      // Ícone de erro (X vermelho)
      icon: SvgPicture.asset(
        'assets/icon/x-circle.svg',
        width: 28,
        height: 28,
        color: const Color(0xFFAC5A5A),
      ),
      // Texto da mensagem de erro
      messageText: Text(
        mensagem,
        style: const TextStyle(
          color: Color(0xFFAC5A5A), // Texto vermelho
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ).show(context);
  }

  /// _CONFIRMARCODIGO
  ///
  /// Descrição: Valida e confirma o código de 6 dígitos via API para ativar a conta.
  /// Parâmetros: nenhum (usa _token e widget.email)
  /// Retorno: Future<void>
  ///
  /// Fluxo: validação local → chamada API → navegação ou erro
  Future<void> _confirmarCodigo() async {
    // Validação local: código deve ter exatamente 6 dígitos
    if (_token.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o código de 6 dígitos.')),
      );
      return;
    }

    // Ativa estado de carregamento
    setState(() => _isLoading = true);

    // Chama API para confirmar código
    final resultado = await _service.confirmarCodigo(
      email: widget.email,
      token: _token,
    );

    // Desativa estado de carregamento
    setState(() => _isLoading = false);

    // Processa resultado da API
    if (resultado == null) {
      // Sucesso: navega para tela de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      // Erro: exibe mensagem de erro
      _mostrarErroFlushbar(resultado);
    }
  }

  /// _REENVIARCODIGO
  ///
  /// Descrição: Solicita reenvio do código de confirmação para o e-mail do usuário.
  /// Parâmetros: nenhum (usa widget.email)
  /// Retorno: Future<void>
  ///
  /// Usado quando usuário não recebe o código inicial ou ele expira.
  Future<void> _reenviarCodigo() async {
    // Ativa estado de carregamento
    setState(() => _isLoading = true);

    // Chama API para reenviar código
    final resultado = await _service.reenviarCodigo(email: widget.email);

    // Desativa estado de carregamento
    setState(() => _isLoading = false);

    // Processa resultado da API
    if (resultado == null) {
      // Sucesso: exibe confirmação via SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código reenviado com sucesso! Verifique seu e-mail.')),
      );
    } else {
      // Erro: exibe mensagem de erro via Flushbar
      _mostrarErroFlushbar(resultado);
    }
  }

  /// BUILD
  ///
  /// Descrição: Constrói interface de confirmação com campo PIN, instruções e botões.
  /// Parâmetros:
  /// - context: Contexto do widget para MediaQuery e navegação
  /// Retorno: Widget Scaffold com layout responsivo
  @override
  Widget build(BuildContext context) {
    // Configuração responsiva baseada no tamanho da tela
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600; // Define se é mobile ou tablet/desktop

    return Scaffold(
      // AppBar simples com título da funcionalidade
      appBar: AppBar(
        title: const Text('Verificar Conta'),
        backgroundColor: Colors.white,
        elevation: 0, // Remove sombra
        foregroundColor: Colors.black, // Texto e ícones pretos
      ),
      backgroundColor: Colors.white,
      // Scroll para evitar overflow em telas pequenas
      body: SingleChildScrollView(
        // Padding responsivo: menor em mobile, maior em desktop
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : size.width * 0.1,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instruções detalhadas para o usuário
            Text(
              'Um código de verificação foi enviado para o seu e-mail. Por favor, insira-o abaixo.\n\n'
              'Caso não receba o código em sua caixa de entrada, verifique sua caixa de spam.\n\n'
              'Este código é válido por até 2 horas.', // Informa tempo de expiração
              style: TextStyle(fontSize: isSmallScreen ? 16 : 18),
            ),
            const SizedBox(height: 30),
            // Campo PIN personalizado para código de 6 dígitos
            PinCodeTextField(
              appContext: context,
              length: 6,                              // Exatamente 6 dígitos
              keyboardType: TextInputType.number,     // Teclado numérico
              autoFocus: true,                        // Foco automático ao abrir tela
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,         // Formato de caixas
                borderRadius: BorderRadius.circular(10),
                // Tamanhos responsivos para diferentes telas
                fieldHeight: isSmallScreen ? 50 : 60,
                fieldWidth: isSmallScreen ? 40 : 50,
                // Cores dos estados do campo
                activeFillColor: Colors.white,        // Cor de fundo ativo
                selectedFillColor: Colors.white,      // Cor de fundo selecionado
                inactiveFillColor: Colors.white,      // Cor de fundo inativo
                activeColor: const Color(0xFF2A2F8C), // Borda azul SUDEMA quando ativo
                selectedColor: const Color(0xFF2A2F8C), // Borda azul quando selecionado
                inactiveColor: Colors.grey.shade400,  // Borda cinza quando inativo
              ),
              enableActiveFill: false,                // Desabilita preenchimento colorido
              // Callback executado a cada digitação
              onChanged: (value) => setState(() => _token = value),
            ),
            const SizedBox(height: 24),
            // Botão principal de verificação do código
            SizedBox(
              width: double.infinity, // Ocupa toda largura disponível
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2F8C), // Azul institucional SUDEMA
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                  ),
                  elevation: 4, // Sombra para destaque
                ),
                // Desabilita botão durante carregamento para evitar múltiplos cliques
                onPressed: _isLoading ? null : _confirmarCodigo,
                child: Text(
                  'Verificar',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18, // Tamanho responsivo
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Divisor visual com texto explicativo
            Row(
              children: [
                // Linha à esquerda
                const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                // Texto central
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Não recebeu o código?',
                    style: TextStyle(
                      color: const Color(0xFF303030),
                      fontWeight: FontWeight.w500,
                      fontSize: isSmallScreen ? 16 : 18, // Tamanho responsivo
                    ),
                  ),
                ),
                // Linha à direita
                const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 30),
            // Botão secundário para reenvio de código
            SizedBox(
              width: double.infinity, // Ocupa toda largura disponível
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,        // Fundo branco (botão secundário)
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    // Borda azul para manter identidade visual
                    side: const BorderSide(color: Color(0xFF2A2F8C), width: 2),
                  ),
                  elevation: 4, // Sombra para destaque
                ),
                // Desabilita botão durante carregamento para evitar spam de requisições
                onPressed: _isLoading ? null : _reenviarCodigo,
                child: Text(
                  'enviar novamente',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18, // Tamanho responsivo
                    color: const Color(0xFF2A2F8C),     // Texto azul (contraste com fundo branco)
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fim da classe _CodigoRegistroState
  // Interface completa de confirmação de cadastro com:
  // - Campo PIN de 6 dígitos responsivo
  // - Botão de verificação com feedback de carregamento
  // - Botão de reenvio de código
  // - Tratamento de erros via Flushbar
  // - Layout responsivo para mobile e desktop
}

