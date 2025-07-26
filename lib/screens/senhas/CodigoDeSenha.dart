/// CODIGO_DE_SENHA
///
/// Responsável por: Segunda etapa do fluxo de recuperação - validação do código
/// de 6 dígitos enviado por e-mail, com opção de reenvio.
/// Utilizado em: Fluxo de recuperação após RecuperacaoSenha para validar código.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sudema_app/screens/senhas/NovaSenha.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Widget Codigodesenha
///
/// Descrição: Tela com campo PIN de 6 dígitos, validação via API,
/// botão de reenvio e layout responsivo.
class Codigodesenha extends StatefulWidget {
  final String email;  // E-mail do usuário (vem da tela anterior)

  const Codigodesenha({super.key, required this.email});

  @override
  State<Codigodesenha> createState() => _CodigodesenhaState();
}

class _CodigodesenhaState extends State<Codigodesenha> {
  String _codigo = '';      // Código de 6 dígitos inserido pelo usuário
  bool _reenviando = false; // Estado de carregamento do botão reenviar

  /// _VERIFICARCODIGO
  ///
  /// Descrição: Valida código de 6 dígitos via API e navega para nova senha.
  /// Parâmetros: nenhum (usa _codigo interno)
  /// Retorno: Future<void>
  ///
  /// Endpoint: POST /password-reset/verify-token
  Future<void> _verificarCodigo() async {
    // Validação local: código deve ter exatamente 6 dígitos
    if (_codigo.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um código válido.')),
      );
      return; // Interrompe execução
    }

    final url = Uri.parse('${dotenv.env['URL_API']}/password-reset/verify-token');

    try {
      /// Integração com API SUDEMA
      ///
      /// Payload:
      /// - email: E-mail do usuário
      /// - userType: 'MOBILE' (fixo)
      /// - token: Código de 6 dígitos
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,  // E-mail da tela anterior
          'userType': 'MOBILE',   // Tipo fixo
          'token': _codigo,       // Código inserido
        }),
      );

      // Processamento da resposta
      if (response.statusCode == 204) {
        // Sucesso: código válido - navega para nova senha
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Novasenha(
              email: widget.email, 
              token: _codigo  // Passa código validado
            ),
          ),
        );
      } else {
        // Erro: código inválido ou expirado
        final error = jsonDecode(response.body)['message'] ?? 'Código inválido.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // Erro de conexão
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão. Tente novamente.')),
      );
    }
  }

  /// _REENVIARCODIGO
  ///
  /// Descrição: Reenvia código de verificação para o e-mail do usuário.
  /// Parâmetros: nenhum (usa widget.email)
  /// Retorno: Future<void>
  ///
  /// Reutiliza mesmo endpoint da primeira etapa (forgot-password).
  /// Botão fica desabilitado durante processo para evitar spam.
  Future<void> _reenviarCodigo() async {
    // Ativa estado de carregamento (desabilita botão)
    setState(() {
      _reenviando = true;
    });

    // Mesmo endpoint da RecuperacaoSenha
    final url = Uri.parse('${dotenv.env['URL_API']}/password-reset/forgot-password');

    try {
      /// Integração com API SUDEMA
      ///
      /// Endpoint: POST /password-reset/forgot-password
      /// Payload:
      /// - email: E-mail do usuário (mesmo da tela anterior)
      /// - userType: 'MOBILE' (fixo)
      ///
      /// Gera novo código e invalida o anterior.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,  // E-mail da tela anterior
          'userType': 'MOBILE',   // Tipo fixo
        }),
      );

      // Processamento da resposta
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Sucesso: novo código enviado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código reenviado com sucesso.'),
            backgroundColor: Colors.green,  // Feedback positivo
          ),
        );
      } else {
        // Erro: extrai mensagem específica da API
        final json = jsonDecode(response.body);
        final error = json['message'] ?? 'Erro ao reenviar código.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // Erro de conexão ou rede
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao conectar com o servidor.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Remove estado de carregamento sempre (habilita botão)
      setState(() {
        _reenviando = false;
      });
    }
  }

  /// BUILD
  ///
  /// Descrição: Constrói tela com instruções, campo PIN, botões e layout responsivo.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Scaffold com estrutura completa
  @override
  Widget build(BuildContext context) {
    // Detecção de dispositivo para layout responsivo
    final larguraTela = MediaQuery.of(context).size.width;
    final bool isTablet = larguraTela >= 600; // Breakpoint para tablet

    // Conteúdo principal da tela
    Widget conteudo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,  // Alinha à esquerda
      mainAxisSize: MainAxisSize.min,                // Tamanho mínimo necessário
      children: [
        // Instruções detalhadas para o usuário
        Text(
          'Um código de verificação foi enviado para o seu e-mail. Por favor, insira-o abaixo.\n\n'
              'Caso não receba o código em sua caixa de entrada, verifique sua caixa de spam.\n\n'
              'Este código é válido por até 5 minutos.',  // Informa timeout
          style: GoogleFonts.lato(fontSize: 16),
        ),
        const SizedBox(height: 30),  // Espaçamento antes do campo PIN
        // Campo PIN de 6 dígitos
        PinCodeTextField(
          appContext: context,
          length: 6,                                    // Exatamente 6 dígitos
          onChanged: (value) => _codigo = value,       // Atualiza variável interna
          keyboardType: TextInputType.number,          // Teclado numérico
          autoFocus: true,                             // Foco automático ao abrir tela
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,              // Formato de caixas
            borderRadius: BorderRadius.circular(10),   // Bordas arredondadas
            fieldHeight: 50,                           // Altura das caixas
            fieldWidth: 40,                            // Largura das caixas
            // Cores de preenchimento (todas brancas)
            activeFillColor: Colors.white,
            selectedFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            // Cores das bordas
            activeColor: const Color(0xFF2A2F8C),      // Azul SUDEMA (ativo)
            selectedColor: const Color(0xFF2A2F8C),    // Azul SUDEMA (selecionado)
            inactiveColor: Colors.grey.shade400,       // Cinza (inativo)
          ),
          enableActiveFill: false,  // Desabilita preenchimento colorido
        ),
        const SizedBox(height: 24),  // Espaçamento antes do botão
        
        // Botão principal de verificação
        SizedBox(
          width: double.infinity,  // Ocupa toda largura
          child: ElevatedButton(
            onPressed: _verificarCodigo,  // Chama método de verificação
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2F8C),  // Azul institucional
              padding: const EdgeInsets.symmetric(vertical: 16),  // Padding vertical
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),  // Bordas arredondadas
              ),
              elevation: 4,  // Sombra para destaque
            ),
            child: Text(
              'Verificar',
              style: GoogleFonts.lato(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 24),  // Espaçamento antes do divisor
        
        // Divisor visual com pergunta central
        Row(
          children: [
            // Linha esquerda
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: 1,
                endIndent: 10,  // Espaço antes do texto
              ),
            ),
            const SizedBox(width: 10),
            // Texto central
            Center(
              child: Text(
                'Não recebeu o código?',
                style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(width: 10),
            // Linha direita
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: 1,
                endIndent: 10,  // Espaço após o texto
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),  // Espaçamento antes do botão reenviar
        
        // Botão secundário de reenvio
        SizedBox(
          width: double.infinity,  // Ocupa toda largura
          child: ElevatedButton(
            // Desabilita botão durante reenvio para evitar spam
            onPressed: _reenviando ? null : _reenviarCodigo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,              // Fundo branco
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(                   // Borda azul
                  color: Color(0xFF2A2F8C), 
                  width: 2
                ),
              ),
              elevation: 4,  // Sombra para destaque
            ),
            // Conteúdo condicional: loading ou texto
            child: _reenviando
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),  // Indicador compacto
            )
                : const Text(
              'Enviar novamente', 
              style: TextStyle(fontSize: 16)  // Texto padrão (cor automática)
            ),
          ),
        ),
      ],
    );

    // Estrutura principal da tela
    return Scaffold(
      // AppBar simples com título
      appBar: AppBar(
        title: const Text('Insira o código'),
        backgroundColor: Colors.white,
        elevation: 0,              // Remove sombra
        foregroundColor: Colors.black,  // Texto e ícones pretos
      ),
      backgroundColor: Colors.white,
      // Body com layout responsivo
      body: Padding(
        padding: EdgeInsets.symmetric(
          // Padding horizontal responsivo
          horizontal: isTablet 
              ? larguraTela * 0.25   // Tablet: 25% da largura como margem
              : 24,                  // Mobile: padding fixo
          vertical: 16,              // Padding vertical fixo
        ),
        child: isTablet
            // Layout para tablet: centralizado
            ? Center(
          child: SingleChildScrollView(
            child: conteudo,  // Conteúdo centralizado
          ),
        )
            // Layout para mobile: scroll normal
            : SingleChildScrollView(
          child: conteudo,  // Conteúdo com scroll
        ),
      ),
    );
  }

  // Fim da classe Codigodesenha
  // 
  // Segunda etapa da recuperação de senha com:
  // 
  // 📱 INTERFACE:
  // - Instruções claras com timeout (5 minutos)
  // - Campo PIN de 6 dígitos com autofocus
  // - Botão principal de verificação (azul)
  // - Divisor visual com pergunta
  // - Botão secundário de reenvio (branco com borda)
  // - Layout responsivo mobile/tablet
  // 
  // ✅ VALIDAÇÕES:
  // - Código deve ter exatamente 6 dígitos
  // - Teclado numérico forçado
  // - Validação local antes da API
  // - Feedback imediato via SnackBar
  // 
  // 🌐 INTEGRAÇÃO API:
  // - Verificação: POST /password-reset/verify-token
  // - Reenvio: POST /password-reset/forgot-password
  // - Status 204 indica código válido
  // - Tratamento de erros com mensagens específicas
  // 
  // 🔄 ESTADOS:
  // - Loading no botão reenviar (evita spam)
  // - Desabilitação durante processo
  // - Feedback visual diferenciado (verde/vermelho)
  // - Navegação com dados validados
}
