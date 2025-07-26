/// CADASTRO_FORM
///
/// Responsável por: Formulário completo de cadastro com validações, máscaras de entrada
/// e integração com API da SUDEMA para registro de novos usuários.
/// Utilizado em: Tela de cadastro como componente principal do formulário.

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/svg.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sudema_app/screens/diversos/TermosCondicoes.dart';
import 'package:sudema_app/screens/login/login.dart';
import 'package:sudema_app/screens/cadastro/confirmar_cadastro.dart';
import 'package:sudema_app/screens/cadastro/controller/cadastro_controller.dart';
import 'package:sudema_app/utils/validarcpf.dart';
import 'package:sudema_app/screens/cadastro/widgets/form_fields.dart';

/// Widget CadastroForm
///
/// Descrição: Formulário completo com 6 campos, validações em tempo real,
/// máscaras de entrada e integração com controller de cadastro.
class CadastroForm extends StatefulWidget {
  const CadastroForm({super.key});

  @override
  State<CadastroForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  // Controller para comunicação com API
  final _controller = RegistroController();

  // Controllers para gerenciar texto dos campos
  final _nomeController = TextEditingController();           // Nome completo
  final _cpfController = TextEditingController();            // CPF com máscara
  final _contatoController = TextEditingController();        // Telefone com máscara
  final _emailController = TextEditingController();          // E-mail
  final _senhaController = TextEditingController();          // Senha
  final _confirmarSenhaController = TextEditingController(); // Confirmação de senha

  // Variáveis para armazenar mensagens de erro de cada campo
  String? _erroNome;           // Erro de validação do nome
  String? _erroCpf;            // Erro de validação do CPF
  String? _erroContato;        // Erro de validação do telefone
  String? _erroEmail;          // Erro de validação do e-mail
  String? _erroSenha;          // Erro de validação da senha
  String? _erroConfirmarSenha; // Erro de confirmação de senha
  String? _erroTermos;         // Erro de aceite dos termos

  // Formatadores de máscara para campos específicos
  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',           // Máscara padrão de CPF
    filter: {"#": RegExp(r'[0-9]')},    // Aceita apenas números
    type: MaskAutoCompletionType.lazy,  // Aplica máscara conforme digitação
  );

  final celularFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',           // Máscara de celular brasileiro
    filter: {"#": RegExp(r'[0-9]')},    // Aceita apenas números
    type: MaskAutoCompletionType.lazy,  // Aplica máscara conforme digitação
  );

  bool _isChecked = false; // Estado do checkbox de aceite dos termos

  /// DISPOSE
  ///
  /// Descrição: Libera recursos dos controllers quando widget é destruído.
  /// Importante para evitar vazamentos de memória.
  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _contatoController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  /// VALIDARSENHASEGURA
  ///
  /// Descrição: Valida se senha atende critérios de segurança.
  /// Parâmetros:
  /// - senha: Senha a ser validada
  /// Retorno: bool - true se senha é segura
  ///
  /// Critérios: mínimo 8 caracteres, letras, números e símbolos.
  bool validarSenhaSegura(String senha) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~%^+=]).{8,}$');
    return regex.hasMatch(senha);
  }

  /// _MOSTRARERROFLUSH
  ///
  /// Descrição: Exibe notificação de erro no topo da tela com ícone SVG e estilo vermelho.
  /// Parâmetros:
  /// - mensagem: Texto do erro a ser exibido
  /// Retorno: void
  ///
  /// Usado para erros de validação geral do formulário.
  void _mostrarErroFlush(String mensagem) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,        // Aparece no topo da tela
      duration: const Duration(seconds: 3),          // Duração de 3 segundos
      backgroundColor: const Color(0xFFF8DFDD),      // Fundo vermelho claro
      // Ícone SVG de erro (X em círculo)
      icon: SvgPicture.asset(
        'assets/icon/x-circle.svg',
        width: 28,
        height: 28,
        color: Colors.red,                            // Ícone vermelho
      ),
      // Texto da mensagem de erro
      messageText: Text(
        mensagem,
        style: const TextStyle(
          color: Colors.red,                          // Texto vermelho
          fontSize: 16,
        ),
      ),
    ).show(context);                                // Exibe o Flushbar
  }

  /// _SUBMETER
  ///
  /// Descrição: Processa submissão do formulário com validações completas e registro via API.
  /// Parâmetros: nenhum (usa controllers e estado interno)
  /// Retorno: Future<void>
  ///
  /// Fluxo: validações → verificação de senhas → chamada API → navegação ou erro
  void _submeter() async {
    // Obtém CPF sem máscara para validação e envio
    final cpf = cpfFormatter.getUnmaskedText();

    // Executa todas as validações e atualiza estado dos erros
    setState(() {
      // Validação 1: Nome completo (deve ter pelo menos nome e sobrenome)
      _erroNome = _nomeController.text.trim().split(' ').length < 2 
          ? 'Digite o nome completo (nome e sobrenome)' 
          : null;
      
      // Validação 2: CPF (obrigatório e deve ser válido)
      _erroCpf = cpf.isEmpty
          ? 'CPF é obrigatório'
          : (!validarCPF(cpf) ? 'CPF inválido' : null);
      
      // Validação 3: Contato (obrigatório)
      _erroContato = _contatoController.text.isEmpty ? 'Contato é obrigatório' : null;
      
      // Validação 4: E-mail (obrigatório)
      _erroEmail = _emailController.text.isEmpty ? 'E-mail é obrigatório' : null;
      
      // Validação 5: Senha (obrigatória e deve ser segura)
      _erroSenha = _senhaController.text.isEmpty
          ? 'Senha é obrigatória'
          : !validarSenhaSegura(_senhaController.text)
              ? 'A senha deve ter no mínimo 8 caracteres, incluir letras, números e caracteres especiais.'
              : null;
      
      // Validação 6: Confirmação de senha (obrigatória)
      _erroConfirmarSenha = _confirmarSenhaController.text.isEmpty 
          ? 'Confirmação de senha é obrigatória' 
          : null;
      
      // Validação 7: Aceite dos termos (obrigatório)
      _erroTermos = !_isChecked ? 'Você deve aceitar os termos para continuar.' : null;
    });

    // Verifica se há algum erro de validação
    if (_erroNome != null || _erroCpf != null || _erroContato != null || 
        _erroEmail != null || _erroSenha != null || _erroConfirmarSenha != null || 
        _erroTermos != null) {
      // Exibe erro geral se algum campo está inválido
      _mostrarErroFlush('Preencha todos os campos obrigatórios.');
      return; // Interrompe execução
    }

    // Validação adicional: senhas devem coincidir
    if (_senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem.')),
      );
      return; // Interrompe execução
    }

    // Chama controller para registrar usuário na API
    final resultado = await _controller.validarERegistrar(
      nome: _nomeController.text,                    // Nome completo
      cpf: cpf,                                      // CPF sem máscara
      telefone: celularFormatter.getUnmaskedText(),  // Telefone sem máscara
      email: _emailController.text,                  // E-mail
      senha: _senhaController.text,                  // Senha
      aceitouTermos: _isChecked,                     // Confirmação de aceite
    );

    // Processa resultado da API
    if (resultado == null) {
      // Sucesso: exibe notificação de sucesso com estilo verde
      Flushbar(
        backgroundColor: const Color(0xFFD2FDE6),    // Fundo verde claro
        duration: const Duration(seconds: 3),
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(12),
        margin: const EdgeInsets.all(12),
        messageText: Row(
          children: [
            // Ícone de sucesso (check verde)
            const Icon(Icons.check_circle_rounded, color: Color(0xFF1B8C00), size: 32),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título da mensagem de sucesso
                  Text(
                    'Cadastro realizado com sucesso!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B8C00),           // Verde escuro
                    ),
                  ),
                  SizedBox(height: 4),
                  // Instrução sobre próximo passo
                  Text(
                    'Enviamos um código de verificação para seu e-mail.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1B8C00),           // Verde escuro
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ).show(context);

      // Aguarda 2.5 segundos para usuário ler a mensagem
      await Future.delayed(const Duration(milliseconds: 2500));

      // Navega para tela de confirmação de código
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CodigoRegistro(email: _emailController.text)),
      );

    } else {
      // Erro: processa mensagem de erro da API
      setState(() {
        // Identifica tipo de erro e associa ao campo correspondente
        if (resultado.toLowerCase().contains('cpf')) {
          _erroCpf = resultado;    // Erro relacionado ao CPF
        } else {
          _erroEmail = resultado;  // Erro relacionado ao e-mail (padrão)
        }
      });
      // Exibe erro também via SnackBar para garantir visibilidade
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado)),
      );
    }
  }

  /// BUILD
  ///
  /// Descrição: Constrói formulário completo de cadastro com 6 campos, validações e botões.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Column com estrutura completa do formulário
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Alinha elementos à esquerda
      children: [
        // Campo 1: Nome completo (obrigatório, deve ter nome e sobrenome)
        CampoTextoPadrao(
          label: "Nome completo",
          controller: _nomeController,
          keyboardType: TextInputType.text,      // Teclado de texto
          hint: "Nome completo",
          erro: _erroNome,                       // Mensagem de erro se inválido
        ),
        // Campo 2: CPF (obrigatório, com máscara e validação)
        CampoTextoPadrao(
          label: "CPF",
          controller: _cpfController,
          keyboardType: TextInputType.number,    // Teclado numérico
          hint: "000.000.000-00",
          erro: _erroCpf,                        // Mensagem de erro se inválido
          formatters: [cpfFormatter],            // Aplica máscara ###.###.###-##
        ),
        // Campo 3: Contato/Telefone (obrigatório, com máscara)
        CampoTextoPadrao(
          label: "Contato",
          controller: _contatoController,
          keyboardType: TextInputType.phone,     // Teclado de telefone
          hint: "(00)00000-0000",
          erro: _erroContato,                    // Mensagem de erro se inválido
          formatters: [celularFormatter],        // Aplica máscara (##) #####-####
        ),
        // Campo 4: E-mail (obrigatório, para autenticação)
        CampoTextoPadrao(
          label: "E-mail",
          controller: _emailController,
          keyboardType: TextInputType.emailAddress, // Teclado de e-mail
          hint: "exemplo@exemplo.com",
          erro: _erroEmail,                         // Mensagem de erro se inválido
        ),
        // Campo 5: Senha (obrigatória, deve ser segura)
        CampoSenha(
          label: "Senha",
          controller: _senhaController,
          erro: _erroSenha,                      // Mensagem de erro se inválida
        ),
        // Texto explicativo sobre critérios de senha segura
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            'A senha deve ter no mínimo 8 caracteres e conter letras, números e caracteres especiais',
            style: TextStyle(fontSize: 14, color: Color(0xFF747474)), // Texto cinza
          ),
        ),
        // Campo 6: Confirmação de senha (deve coincidir com senha)
        CampoSenha(
          label: "Confirme sua senha",
          controller: _confirmarSenhaController,
          erro: _erroConfirmarSenha,             // Mensagem de erro se inválida
        ),
        const SizedBox(height: 8),
        // Checkbox de declaração de veracidade das informações
        Row(
          children: [
            Checkbox(
              activeColor: const Color(0xFF2A2F8C),  // Cor azul SUDEMA quando marcado
              value: _isChecked,                     // Estado atual do checkbox
              shape: const CircleBorder(),           // Formato circular
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;        // Atualiza estado
                });
              },
            ),
            // Texto da declaração de responsabilidade
            const Expanded(
              child: Text(
                'Declaro que as informações acima prestadas são verdadeiras, e assumo a inteira responsabilidade pelas mesmas.',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
        // Mensagem de erro do checkbox (se não marcado)
        if (_erroTermos != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              _erroTermos!,
              style: const TextStyle(color: Colors.red, fontSize: 12), // Texto vermelho
            ),
          ),
        const SizedBox(height: 20),
        // Link para Termos e Condições (obrigatório para conformidade legal)
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Ao usar este aplicativo você concorda com os',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                TextSpan(
                  text: ' Termos e Condições',
                  style: const TextStyle(
                    color: Color(0xFF2A2F8C),           // Azul SUDEMA
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  // Reconhecedor de toque para navegar para tela de termos
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Termoscondicoes()),
                      );
                    },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Botão principal de submissão do formulário
        Center(
          child: ElevatedButton(
            onPressed: _submeter,                    // Chama método de submissão
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B8C00), // Verde (cor de sucesso)
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 140),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Bordas bem arredondadas
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,                 // Ajusta tamanho se necessário
              child: Text(
                'Criar Conta',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Link para navegar para tela de login (usuários existentes)
        Center(
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Já possui uma conta? ',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                TextSpan(
                  text: 'Faça login',
                  style: const TextStyle(
                    color: Color(0xFF2A2F8C),           // Azul SUDEMA
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline, // Sublinhado para indicar link
                  ),
                  // Reconhecedor de toque para navegar para tela de login
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                    },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20), // Espaçamento final
      ],
    );
  }

  // Fim da classe _CadastroFormState
  // 
  // Formulário completo de cadastro com:
  // - 6 campos obrigatórios com validações específicas
  // - Máscaras de entrada para CPF e telefone
  // - Validação de senha segura (8+ chars, letras, números, símbolos)
  // - Checkbox de declaração de veracidade
  // - Links para termos e condições e tela de login
  // - Feedback visual com Flushbar (sucesso/erro)
  // - Integração com API SUDEMA via controller
  // - Navegação automática para confirmação de código
}
