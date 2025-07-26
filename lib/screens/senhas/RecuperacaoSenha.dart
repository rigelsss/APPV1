/// RECUPERACAO_SENHA
///
/// Responsável por: Tela inicial do fluxo de recuperação de senha com validação
/// de e-mail, integração com API e navegação para próxima etapa.
/// Utilizado em: Login e alteração de senha para iniciar processo de recuperação.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';
import 'package:sudema_app/screens/senhas/CodigoDeSenha.dart';
import 'package:sudema_app/screens/widgets/appbar_login.dart';

/// Enum para tipos de mensagem do Flushbar
enum TipoMensagem { sucesso, erro, aviso }

/// Widget RecuperacaoSenha
///
/// Descrição: Tela com campo de e-mail, validações, layout responsivo
/// e integração com API para envio de código de recuperação.
class RecuperacaoSenha extends StatefulWidget {
  const RecuperacaoSenha({super.key});

  @override
  State<RecuperacaoSenha> createState() => _RecuperacaoSenhaState();
}

class _RecuperacaoSenhaState extends State<RecuperacaoSenha> {
  final TextEditingController _emailController = TextEditingController();  // Controller do campo e-mail
  String? _erroEmail;  // Mensagem de erro do e-mail (null = sem erro)

  // Constantes de design e configuração
  static const Color _primaryColor = Color(0xFF2A2F8C);    // Azul institucional SUDEMA
  // ignore: unused_field
  static const double _smallScreenWidth = 500;             // Breakpoint para tablet
  static const String _userType = 'MOBILE';                // Tipo de usuário fixo para app

  /// DISPOSE
  ///
  /// Descrição: Libera recursos do controller quando widget é destruído.
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// _ISVALIDEMAIL
  ///
  /// Descrição: Valida formato de e-mail usando regex.
  /// Parâmetros:
  /// - email: String do e-mail a ser validado
  /// Retorno: bool - true se válido, false se inválido
  bool _isValidEmail(String email) {
    // Regex para validação de e-mail padrão
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  /// _ENVIAREMAILDERECUPERACAO
  ///
  /// Descrição: Envia requisição para API solicitando código de recuperação.
  /// Parâmetros:
  /// - email: E-mail do usuário para recuperação
  /// Retorno: Future<void>
  ///
  /// Endpoint: POST /password-reset/forgot-password
  Future<void> _enviarEmailDeRecuperacao(String email) async {
    final url = Uri.parse('${dotenv.env['URL_API']}/password-reset/forgot-password');
    
    try {
      /// Integração com API SUDEMA
      ///
      /// Payload:
      /// - email: E-mail do usuário
      /// - userType: 'MOBILE' (fixo para app)
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email, 
          'userType': _userType  // Tipo fixo para usuários mobile
        }),
      );
      _processarResposta(response, email);  // Processa resposta da API
    } catch (e) {
      // Erro de conexão ou rede
      debugPrint('Erro ao enviar solicitação: $e');
      _mostrarErroConexao();
    }
  }

  /// _PROCESSARRESPOSTA
  ///
  /// Descrição: Processa resposta da API baseada no status code.
  /// Parâmetros:
  /// - response: Resposta HTTP da API
  /// - email: E-mail usado (para navegação)
  /// Retorno: void
  void _processarResposta(http.Response response, String email) {
    if (response.statusCode == 200 || response.statusCode == 204) {
      // Sucesso: código enviado
      _processarRespostaSucesso(email);
    } else if (response.statusCode == 400) {
      // Erro 400: e-mail não cadastrado
      _definirErroEmail('Este e-mail não está cadastrado em nosso sistema.');
    } else {
      // Outros erros: processa mensagem da API
      _processarRespostaErro(response);
    }
  }

  /// _PROCESSARRESPOSTASUCESSO
  ///
  /// Descrição: Processa sucesso - limpa erros, mostra feedback e navega.
  /// Parâmetros:
  /// - email: E-mail para passar para próxima tela
  /// Retorno: void
  void _processarRespostaSucesso(String email) {
    _limparErroEmail();  // Remove erro visual do campo
    _mostrarFlushbarPadrao('Código enviado para o e-mail informado.', TipoMensagem.sucesso);
    // Navega para tela de inserção de código
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Codigodesenha(email: email)),
    );
  }

  /// _PROCESSARRESPOSTAERRO
  ///
  /// Descrição: Processa erro - extrai mensagem da API e exibe via Flushbar.
  /// Parâmetros:
  /// - response: Resposta HTTP com erro
  /// Retorno: void
  void _processarRespostaErro(http.Response response) {
    _limparErroEmail();  // Remove erro visual do campo
    try {
      // Tenta extrair mensagem específica da API
      final error = jsonDecode(response.body)['message'] ?? 'Erro ao enviar e-mail.';
      _mostrarFlushbarPadrao(error, TipoMensagem.erro);
    } catch (_) {
      // Fallback se não conseguir fazer parse do JSON
      _mostrarFlushbarPadrao('Erro ao enviar e-mail.', TipoMensagem.erro);
    }
  }

  /// _MOSTRARERROCONEXAO
  ///
  /// Descrição: Exibe erro de conexão via Flushbar e limpa erro visual do campo.
  /// Parâmetros: nenhum
  /// Retorno: void
  void _mostrarErroConexao() {
    _limparErroEmail();  // Remove erro visual do campo
    _mostrarFlushbarPadrao('Erro de conexão. Tente novamente.', TipoMensagem.erro);
  }

  /// _DEFINIRERROEMAIL
  ///
  /// Descrição: Define mensagem de erro no campo e-mail e atualiza UI.
  /// Parâmetros:
  /// - erro: Mensagem de erro a ser exibida
  /// Retorno: void
  void _definirErroEmail(String erro) {
    setState(() {
      _erroEmail = erro;  // Define erro (exibido no TextField)
    });
  }

  /// _LIMPARERROEMAIL
  ///
  /// Descrição: Remove mensagem de erro do campo e-mail e atualiza UI.
  /// Parâmetros: nenhum
  /// Retorno: void
  void _limparErroEmail() {
    setState(() {
      _erroEmail = null;  // Remove erro (campo volta ao normal)
    });
  }

  /// _VALIDAREENVIARMAIL
  ///
  /// Descrição: Método principal acionado pelo botão - valida e-mail e inicia envio.
  /// Parâmetros: nenhum (usa _emailController)
  /// Retorno: void
  ///
  /// Fluxo: trim → validação local → chamada API ou erro visual
  void _validarEEnviarEmail() {
    String email = _emailController.text.trim();  // Remove espaços extras

    // Validação local: campo preenchido + formato válido
    if (email.isEmpty || !_isValidEmail(email)) {
      _definirErroEmail('Por favor, insira um e-mail válido.');
      return;  // Interrompe execução se inválido
    }

    // E-mail válido: inicia processo de recuperação
    _enviarEmailDeRecuperacao(email);
  }

  /// _BUILDEMAILEXTFIELD
  ///
  /// Descrição: Constrói campo de e-mail com validação visual e limpeza automática de erro.
  /// Parâmetros: nenhum
  /// Retorno: Widget TextField configurado
  ///
  /// Recursos: borda responsiva a erro, teclado de e-mail, limpeza de erro ao digitar
  Widget _buildEmailTextField() {
    return TextField(
      controller: _emailController,  // Controller para gerenciar texto
      decoration: InputDecoration(
        // Borda padrão (estado normal)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),  // Bordas arredondadas
        ),
        labelText: 'E-mail',           // Label flutuante
        errorText: _erroEmail,         // Mensagem de erro (null = sem erro)
        // Borda quando campo está focado
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),  // Mesma curvatura
          borderSide: BorderSide(color: Colors.grey, width: 1.5),  // Cinza padrão
        ),
        // Borda quando campo está habilitado (responsiva a erro)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),  // Mesma curvatura
          borderSide: BorderSide(
            // Cor condicional: vermelho se erro, cinza se normal
            color: _erroEmail != null ? Colors.red : Colors.grey,
          ),
        ),
      ),
      keyboardType: TextInputType.emailAddress,  // Teclado otimizado para e-mail
      // Limpeza automática de erro ao começar a digitar
      onChanged: (_) {
        if (_erroEmail != null) {
          _limparErroEmail();  // Remove erro visual imediatamente
        }
      },
    );
  }

  /// _BUILDSUBMITBUTTON
  ///
  /// Descrição: Constrói botão principal de envio com estilo institucional SUDEMA.
  /// Parâmetros: nenhum
  /// Retorno: Widget SizedBox com ElevatedButton
  ///
  /// Estilo: azul SUDEMA, bordas arredondadas, largura total, fonte Lato
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,  // Ocupa toda largura disponível
      child: ElevatedButton(
        onPressed: _validarEEnviarEmail,  // Chama método principal
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,  // Azul institucional SUDEMA (#2A2F8C)
          padding: EdgeInsets.symmetric(vertical: 15),  // Padding vertical confortável
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),  // Bordas bem arredondadas
          ),
        ),
        child: Text(
          'Enviar código de verificação',
          style: GoogleFonts.lato(
            color: Colors.white,  // Texto branco para contraste
            fontSize: 16          // Tamanho legível
          ),
        ),
      ),
    );
  }

  /// BUILD
  ///
  /// Descrição: Constrói tela inicial com instruções, campo de e-mail e botão de envio.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Scaffold com layout responsivo completo
  @override
  Widget build(BuildContext context) {
    // Detecção de dispositivo para layout responsivo
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;  // Breakpoint para tablet

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar customizada com título específico
      appBar: AppBarDenuncia(title: 'Recuperação de senha'),
      // Body com LayoutBuilder para responsividade
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Conteúdo principal da tela
          final content = Column(
            mainAxisSize: MainAxisSize.min,  // Tamanho mínimo necessário
            // Alinhamento responsivo: centro (tablet) ou esquerda (mobile)
            crossAxisAlignment: isTablet ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              // Instruções para o usuário
              Text(
                'Informe o e-mail associado à sua conta para alteração de senha.',
                style: GoogleFonts.lato(fontSize: 16),
                // Alinhamento de texto responsivo
                textAlign: isTablet ? TextAlign.center : TextAlign.start,
              ),
              SizedBox(height: 20),   // Espaçamento após instruções
              _buildEmailTextField(), // Campo de e-mail
              SizedBox(height: 24),   // Espaçamento antes do botão
              _buildSubmitButton(),   // Botão de envio
            ],
          );

          // Layout responsivo com scroll
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              // Padding horizontal responsivo
              horizontal: isTablet ? 24 : 16,  // Tablet: mais padding, Mobile: menos
              vertical: isTablet ? 0 : 24,     // Tablet: sem padding vertical, Mobile: com padding
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

  /// _MOSTRARFLUSHBARPADRAO
  ///
  /// Descrição: Exibe Flushbar padronizado com cores e ícones baseados no tipo.
  /// Parâmetros:
  /// - mensagem: Texto a ser exibido
  /// - tipo: TipoMensagem (sucesso, erro, aviso)
  /// Retorno: void
  ///
  /// Configuração: posição TOP, duração 3s, animação 500ms
  void _mostrarFlushbarPadrao(String mensagem, TipoMensagem tipo) {
    Color cor;
    Icon icone;

    // Configuração baseada no tipo de mensagem
    switch (tipo) {
      case TipoMensagem.sucesso:
        cor = Colors.green;                                    // Verde para sucesso
        icone = Icon(Icons.check_circle, color: Colors.white); // Ícone de check
        break;
      case TipoMensagem.erro:
        cor = Colors.red;                                      // Vermelho para erro
        icone = Icon(Icons.error, color: Colors.white);       // Ícone de erro
        break;
      case TipoMensagem.aviso:
        cor = Colors.orange;                                   // Laranja para aviso
        icone = Icon(Icons.warning, color: Colors.white);     // Ícone de aviso
        break;
    }

    // Exibe Flushbar configurado
    Flushbar(
      message: mensagem,                           // Mensagem principal
      duration: Duration(seconds: 3),              // Duração de 3 segundos
      backgroundColor: cor,                        // Cor baseada no tipo
      flushbarPosition: FlushbarPosition.TOP,      // Posição no topo
      borderRadius: BorderRadius.circular(8),      // Bordas arredondadas
      margin: EdgeInsets.all(16),                  // Margem externa
      animationDuration: Duration(milliseconds: 500), // Animação de 500ms
      icon: icone,                                 // Ícone baseado no tipo
    ).show(context);
  }

  // Fim da classe RecuperacaoSenha
  // 
  // Primeira etapa da recuperação de senha com:
  // 
  // 📱 INTERFACE RESPONSIVA:
  // - Detecção automática mobile/tablet (600dp breakpoint)
  // - Alinhamento adaptativo (centro vs esquerda)
  // - Padding diferenciado por dispositivo
  // - Largura máxima controlada em tablets (500px)
  // - Layout centralizado com ConstrainedBox
  // 
  // ✉️ CAMPO DE E-MAIL:
  // - Validação via regex padrão
  // - Borda responsiva a erro (vermelho/cinza)
  // - Teclado otimizado para e-mail
  // - Limpeza automática de erro ao digitar
  // - Label flutuante e errorText integrado
  // 
  // 💬 FEEDBACK VISUAL:
  // - Flushbar padronizado com 3 tipos
  // - Cores semânticas (verde/vermelho/laranja)
  // - Ícones apropriados para cada tipo
  // - Posição TOP com animação suave
  // - Duração de 3 segundos
  // 
  // 🌐 INTEGRAÇÃO API:
  // - Endpoint POST /password-reset/forgot-password
  // - Payload com email e userType: 'MOBILE'
  // - Tratamento de status 200/204 (sucesso) e 400 (e-mail não cadastrado)
  // - Navegação para próxima etapa com e-mail validado
  // 
  // 🔄 ESTADOS:
  // - Erro visual no campo vs Flushbar
  // - Limpeza automática de erros
  // - Validação local antes da API
  // - Tratamento de erros de conexão
}
