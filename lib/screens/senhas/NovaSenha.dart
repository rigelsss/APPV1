/// NOVA_SENHA
///
/// Responsável por: Terceira e última etapa do fluxo de recuperação - definição
/// de nova senha com validações, confirmação e finalização do processo.
/// Utilizado em: Final do fluxo de recuperação após CodigoDeSenha para redefinir senha.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/login/login.dart';
import 'package:sudema_app/screens/widgets/appbar_login.dart';

/// Widget Novasenha
///
/// Descrição: Tela com 2 campos de senha (nova e confirmação), validações
/// locais, integração com API e navegação para login após sucesso.
class Novasenha extends StatefulWidget {
  final String email;  // E-mail do usuário (das telas anteriores)
  final String token;  // Token validado (da tela anterior)

  const Novasenha({super.key, required this.email, required this.token});

  @override
  State<Novasenha> createState() => _NovasenhaState();
}

class _NovasenhaState extends State<Novasenha> {
  // Controllers para gerenciar texto dos campos
  final _novaSenhaController = TextEditingController();      // Nova senha
  final _confirmarSenhaController = TextEditingController(); // Confirmação

  // Estados de visibilidade das senhas
  bool _obscureNovaSenha = true;      // Visibilidade da nova senha
  bool _obscureConfirmarSenha = true; // Visibilidade da confirmação
  bool _isLoading = false;            // Estado de carregamento

  /// _RESETARSENHA
  ///
  /// Descrição: Método principal para redefinir senha com validações e API.
  /// Parâmetros: nenhum (usa controllers internos)
  /// Retorno: Future<void>
  ///
  /// Fluxo: validações locais → requisição API → feedback → navegação
  Future<void> _resetarSenha() async {
    final novaSenha = _novaSenhaController.text.trim();
    final confirmarSenha = _confirmarSenhaController.text.trim();

    // Validação 1: Senha deve ter pelo menos 8 caracteres
    if (novaSenha.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A senha deve ter no mínimo 8 caracteres.'), backgroundColor: Colors.red),
      );
      return; // Interrompe execução
    }

    // Validação 2: Senhas devem coincidir
    if (novaSenha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.'), backgroundColor: Colors.red),
      );
      return; // Interrompe execução
    }

    // Ativa estado de carregamento
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('${dotenv.env['URL_API']}/password-reset/reset-password');
    
    // Logs para debug (remover em produção)
    debugPrint('🔐 Enviando solicitação para redefinir senha...');
    debugPrint('📧 Email: ${widget.email}');
    debugPrint('🔑 Token: ${widget.token}');
    debugPrint('🔒 Nova senha: $novaSenha');
    debugPrint('🌐 URL: $url');

    try {
      /// Integração com API SUDEMA
      ///
      /// Endpoint: POST /password-reset/reset-password
      /// Payload:
      /// - email: E-mail do usuário
      /// - userType: 'MOBILE' (fixo)
      /// - token: Código validado na etapa anterior
      /// - novaSenha: Nova senha definida pelo usuário
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,    // E-mail das telas anteriores
          'userType': 'MOBILE',     // Tipo fixo
          'token': widget.token,    // Token validado
          'novaSenha': novaSenha,   // Nova senha
        }),
      );

      // Processamento da resposta
      if (response.statusCode == 204) {
        // Sucesso: senha redefinida
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha redefinida com sucesso!'), backgroundColor: Colors.green),
        );
        // Navega para login limpando todo o stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,  // Remove todas as rotas anteriores
        );
      } else {
        // Erro: extrai mensagem da API
        final error = jsonDecode(response.body)['message'] ?? 'Erro ao redefinir a senha.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
        // Logs de debug para erro
        debugPrint('❗ Status inesperado: ${response.statusCode}');
        debugPrint('❗ Corpo da resposta: ${response.body}');
      }
    } catch (e) {
      // Erro de conexão
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão. Tente novamente.'), backgroundColor: Colors.red),
      );
    } finally {
      // Remove estado de carregamento sempre
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// DISPOSE
  ///
  /// Descrição: Libera recursos dos controllers quando widget é destruído.
  @override
  void dispose() {
    _novaSenhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  // Fim da classe Novasenha
  // 
  // Tela final de recuperação de senha com:
  // 
  // ✅ VALIDAÇÕES:
  // - Senha mínima de 8 caracteres
  // - Confirmação de senha obrigatória
  // - Validação de coincidência
  // - Trim automático para remover espaços
  // 
  // 🔒 SEGURANÇA:
  // - Toggle de visibilidade independente
  // - Token validado da etapa anterior
  // - Integração segura com API
  // - Logs de debug para desenvolvimento
  // 
  // 🌐 INTEGRAÇÃO API:
  // - Endpoint POST /password-reset/reset-password
  // - Payload completo com email, token e nova senha
  // - Status 204 indica sucesso
  // - Extração de mensagens de erro da API
  // 
  // 📱 UX/UI:
  // - Estado de loading durante processo
  // - Feedback via SnackBar (verde/vermelho)
  // - Layout responsivo para mobile/tablet
  // - Campos com toggle de visibilidade
  // - Instruções claras sobre senha forte
  // 
  // 🗺️ NAVEGAÇÃO:
  // - pushAndRemoveUntil limpa todo o stack
  // - Redirecionamento para login após sucesso
  // - Finalização completa do fluxo de recuperação

  /// BUILD
  ///
  /// Descrição: Constrói tela final com instruções, 2 campos de senha e botão de redefinir.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Scaffold com layout responsivo e conteúdo centralizado
  @override
  Widget build(BuildContext context) {
    // Detecção de dispositivo para layout responsivo
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;  // Breakpoint para tablet

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar customizada com título específico
      appBar: AppBarDenuncia(title: 'Crie uma nova senha'),
      // Body com LayoutBuilder para responsividade
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Conteúdo principal da tela
          final content = Column(
            mainAxisSize: MainAxisSize.min,  // Tamanho mínimo necessário
            // Alinhamento responsivo: centro (tablet) ou esquerda (mobile)
            crossAxisAlignment: isTablet ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              // Instruções detalhadas sobre senha forte
              Text(
                'Crie uma senha forte com, no mínimo, oito caracteres, contendo uma combinação de letras, números e símbolos.',
                style: GoogleFonts.lato(fontSize: 16),
                // Alinhamento responsivo do texto
                textAlign: isTablet ? TextAlign.center : TextAlign.start,
              ),
              const SizedBox(height: 20),  // Espaçamento após instruções
              
              // Label do primeiro campo
              const Align(
                alignment: Alignment.centerLeft,  // Sempre alinhado à esquerda
                child: Text('Nova senha', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 8),   // Espaço entre label e campo
              
              // Campo 1: Nova senha
              TextField(
                controller: _novaSenhaController,  // Controller da nova senha
                obscureText: _obscureNovaSenha,    // Controla visibilidade
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),  // Borda padrão
                  // Ícone de toggle de visibilidade
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNovaSenha ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNovaSenha = !_obscureNovaSenha;  // Alterna visibilidade
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),  // Espaçamento entre campos
              
              // Label do segundo campo
              const Align(
                alignment: Alignment.centerLeft,  // Sempre alinhado à esquerda
                child: Text('Confirmar a nova senha', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 8),   // Espaço entre label e campo
              
              // Campo 2: Confirmação da nova senha
              TextField(
                controller: _confirmarSenhaController,  // Controller da confirmação
                obscureText: _obscureConfirmarSenha,    // Controla visibilidade (independente)
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),  // Borda padrão
                  // Ícone de toggle de visibilidade (independente do primeiro campo)
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmarSenha ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmarSenha = !_obscureConfirmarSenha;  // Alterna visibilidade
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),  // Espaçamento antes do botão
              
              // Botão de redefinir com estado condicional
              SizedBox(
                width: double.infinity,  // Ocupa toda largura disponível
                child: _isLoading
                    // Estado de carregamento: indicador circular
                    ? const Center(child: CircularProgressIndicator())
                    // Estado normal: botão de redefinir
                    : ElevatedButton(
                  onPressed: _resetarSenha,  // Chama método principal
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF11B8C00),  // Verde (nota: possível erro no código da cor)
                    padding: const EdgeInsets.symmetric(vertical: 16),  // Padding vertical generoso
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),  // Bordas bem arredondadas
                    ),
                  ),
                  child: const Text(
                    'Redefinir',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );

          // Layout responsivo com scroll
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              // Padding horizontal responsivo
              horizontal: isTablet ? 24 : 16,  // Tablet: mais padding, Mobile: menos
              vertical: isTablet ? 0 : 16,     // Tablet: sem padding vertical, Mobile: com padding
            ),
            child: isTablet
                // Layout para tablet: centralizado com largura máxima
                ? Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 500,                    // Largura máxima de 500px
                  minHeight: constraints.maxHeight, // Altura mínima da tela
                ),
                child: Center(child: content),    // Conteúdo duplamente centralizado
              ),
            )
                // Layout para mobile: conteúdo direto
                : content,  // Sem centralização adicional
          );
        },
      ),
    );
  }

  // Fim da classe Novasenha
  // 
  // Tela final de recuperação de senha com:
  // 
  // 📱 INTERFACE RESPONSIVA:
  // - Detecção automática mobile/tablet (600dp breakpoint)
  // - Alinhamento adaptativo (centro vs esquerda)
  // - Padding diferenciado por dispositivo
  // - Largura máxima controlada em tablets (500px)
  // - Layout centralizado com ConstrainedBox
  // 
  // 🔒 CAMPOS DE SENHA:
  // - 2 campos independentes (nova + confirmação)
  // - Toggle de visibilidade separado para cada campo
  // - Labels claras e alinhadas à esquerda
  // - Bordas padrão OutlineInputBorder
  // - Controllers dedicados para cada campo
  // 
  // ⚙️ ESTADO CONDICIONAL:
  // - Botão vs CircularProgressIndicator
  // - Desabilitação durante processo
  // - Feedback visual de carregamento
  // - Cores semânticas (verde para ação positiva)
  // 
  // 📝 INSTRUÇÕES:
  // - Texto explicativo sobre senha forte
  // - Critérios claros (8+ caracteres, letras, números, símbolos)
  // - Alinhamento responsivo do texto
  // - Fonte Google Fonts Lato
  // 
  // 🟢 FINALIZAÇÃO:
  // - Última etapa do fluxo de recuperação
  // - Integração completa com API SUDEMA
  // - Navegação para login após sucesso
  // - Limpeza total do stack de navegação
}
