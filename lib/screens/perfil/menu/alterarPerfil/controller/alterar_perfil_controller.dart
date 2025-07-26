/// ALTERAR_PERFIL_CONTROLLER
///
/// Responsável por: Controller para edição de perfil com gerenciamento de estado,
/// validações, máscaras de entrada e integração com API.
/// Utilizado em: EditarPerfilForm para processar edição de dados pessoais.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../service/editar_perfil_service.dart';

/// Classe EditarPerfilController
///
/// Descrição: Controller com máscaras de entrada, validações de formulário,
/// gerenciamento de token JWT e integração com service de atualização.
class EditarPerfilController {
  final BuildContext context;  // Contexto para feedback visual

  EditarPerfilController({required this.context});

  // Chave global para validação do formulário
  final formKey = GlobalKey<FormState>();
  
  // Controllers para gerenciar texto dos campos
  final nomeController = TextEditingController();     // Nome completo
  final cpfController = TextEditingController();      // CPF com máscara
  final telefoneController = TextEditingController(); // Telefone com máscara

  // Máscara para CPF: XXX.XXX.XXX-XX
  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',     // Formato brasileiro padrão
    filter: {"#": RegExp(r'\d')}, // Apenas dígitos
  );

  // Máscara para telefone: (XX) XXXXX-XXXX
  final telMask = MaskTextInputFormatter(
    mask: '(##) #####-####',     // Formato celular brasileiro
    filter: {"#": RegExp(r'\d')}, // Apenas dígitos
  );

  // Dados de autenticação
  String? token;  // Token JWT para autenticação
  String? id;     // ID do usuário extraído do JWT

  /// RECUPERARUSUARIOID
  ///
  /// Descrição: Recupera e valida token JWT, extrai ID do usuário para operações.
  /// Parâmetros:
  /// - onSuccess: Callback executado após sucesso na recuperação
  /// Retorno: Future<void>
  ///
  /// Fluxo: token salvo → validação → decodificação → extração ID → callback
  Future<void> recuperarUsuarioId(Function onSuccess) async {
    // Obtém token salvo localmente
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');

    // Valida existência e expiração do token
    if (savedToken != null && !JwtDecoder.isExpired(savedToken)) {
      // Token válido: decodifica e extrai informações
      final decodedToken = JwtDecoder.decode(savedToken);
      token = savedToken;           // Armazena token para uso posterior
      id = decodedToken['id'];      // Extrai ID do payload JWT
      onSuccess();                  // Executa callback de sucesso
    } else {
      // Token inválido ou expirado: redireciona para login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Sessão expirada. Faça login novamente.')),
      );
      // Substitui tela atual por login (limpa stack)
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  /// PREENCHERCAMPOSINICIAIS
  ///
  /// Descrição: Preenche campos do formulário com dados atuais do usuário,
  /// aplicando máscaras de formatação para CPF e telefone.
  /// Parâmetros:
  /// - nome: Nome completo atual
  /// - telefone: Telefone atual (pode vir com ou sem formatação)
  /// - cpf: CPF atual (pode vir com ou sem formatação)
  /// Retorno: void
  ///
  /// Aplica limpeza de caracteres não numéricos antes de aplicar máscaras.
  void preencherCamposIniciais({
    required String nome,
    required String telefone,
    required String cpf,
  }) {
    // Nome: sem formatação especial
    nomeController.text = nome;
    
    // Telefone: remove caracteres não numéricos e aplica máscara
    telefoneController.text = telMask.maskText(
      telefone.replaceAll(RegExp(r'\D'), '')  // Remove tudo exceto dígitos
    );
    
    // CPF: remove caracteres não numéricos e aplica máscara
    cpfController.text = cpfMask.maskText(
      cpf.replaceAll(RegExp(r'\D'), '')       // Remove tudo exceto dígitos
    );
  }

  /// SALVARDADOS
  ///
  /// Descrição: Método principal para salvar alterações do perfil via API.
  /// Parâmetros:
  /// - onSuccess: Callback executado após sucesso
  /// - onFailure: Callback executado após falha
  /// Retorno: Future<void>
  ///
  /// Fluxo: validação → preparação dados → chamada API → feedback → callback
  Future<void> salvarDados(VoidCallback onSuccess, VoidCallback onFailure) async {
    // Etapa 1: Validação do formulário
    if (!formKey.currentState!.validate()) return;  // Interrompe se inválido

    // Etapa 2: Validação de configuração
    final baseUrl = dotenv.env['URL_API'];
    if (baseUrl == null || baseUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ URL da API não configurada')),
      );
      return;  // Interrompe se API não configurada
    }

    // Etapa 3: Preparação dos dados para envio
    final nome = nomeController.text.trim();                      // Remove espaços extras
    final cpf = cpfController.text.replaceAll(RegExp(r'\D'), ''); // Remove máscara
    final telefone = telefoneController.text.replaceAll(RegExp(r'\D'), ''); // Remove máscara

    // Etapa 4: Chamada da API via service
    final response = await UsuarioService.atualizarUsuario(
      id: id!,      // ID extraído do JWT
      token: token!, // Token para autenticação
      dados: {
        'nome': nome,              // Nome limpo
        'telefone': telefone,      // Telefone apenas dígitos
        'cpf': cpf,                // CPF apenas dígitos
        'userType': 'MOBILE',      // Tipo fixo para app mobile
      },
    );

    // Etapa 5: Processamento da resposta
    if (response.statusCode == 200) {
      // Sucesso: exibe feedback positivo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Dados atualizados com sucesso')),
      );
      onSuccess();  // Executa callback de sucesso
    } else {
      // Erro: log para debug e feedback ao usuário
      debugPrint('❌ Erro ${response.statusCode}: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Erro ao atualizar: ${response.statusCode} - ${response.body}'),
        ),
      );
      onFailure();  // Executa callback de falha
    }
  }

  /// DISPOSE
  ///
  /// Descrição: Libera recursos dos controllers quando não são mais necessários.
  /// Parâmetros: nenhum
  /// Retorno: void
  void dispose() {
    // Libera todos os controllers de texto
    nomeController.dispose();
    cpfController.dispose();
    telefoneController.dispose();
  }

  // Fim da classe EditarPerfilController
  // 
  // Controller completo para edição de perfil com:
  // 
  // 🔒 SEGURANÇA:
  // - Validação de token JWT com expiração
  // - Extração segura de ID do payload
  // - Redirecionamento para login se inválido
  // - Limpeza de dados antes do envio
  // 
  // 🎨 MÁSCARAS E FORMATAÇÃO:
  // - Máscara automática para CPF (XXX.XXX.XXX-XX)
  // - Máscara automática para telefone ((XX) XXXXX-XXXX)
  // - Preenchimento inicial com dados atuais
  // - Remoção de máscaras antes do envio
  // 
  // ✅ VALIDAÇÕES:
  // - Validação de formulário antes do envio
  // - Verificação de configuração da API
  // - Trim automático para remover espaços
  // - Callbacks para sucesso e falha
  // 
  // 🌐 INTEGRAÇÃO API:
  // - Service dedicado para atualização
  // - Payload estruturado com userType
  // - Tratamento de diferentes status codes
  // - Feedback visual via SnackBar
  // 
  // 📱 UX/UI:
  // - Feedback imediato para usuário
  // - Mensagens de sucesso e erro
  // - Debug logs para desenvolvimento
  // - Callbacks para navegação
}
