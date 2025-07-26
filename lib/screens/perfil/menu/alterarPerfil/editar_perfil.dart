/// EDITAR_PERFIL
///
/// Responsável por: Tela de edição de perfil do usuário com dados pré-preenchidos,
/// carregamento de ID via JWT e integração com controller para atualização.
/// Utilizado em: Menu de perfil para permitir edição de dados pessoais.

import 'package:flutter/material.dart';

import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/controller/alterar_perfil_controller.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/form/alterar_perfil_form.dart';

/// Widget EditarPerfil
///
/// Descrição: Tela com formulário de edição, estado de carregamento e
/// inicialização de controller com dados atuais do usuário.
class EditarPerfil extends StatefulWidget {
  final String nomeAtual;      // Nome atual do usuário
  final String telefoneAtual;  // Telefone atual do usuário
  final String cpfAtual;       // CPF atual do usuário

  const EditarPerfil({
    super.key,
    required this.nomeAtual,
    required this.telefoneAtual,
    required this.cpfAtual,
  });

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final int _currentIndex = -1;                    // Índice da navegação (-1 = desabilitada)
  late final EditarPerfilController controller;   // Controller para gerenciar edição

  bool carregando = true;  // Estado de carregamento inicial

  /// INITSTATE
  ///
  /// Descrição: Inicializa controller, recupera ID do usuário via JWT e
  /// preenche campos com dados atuais.
  /// 
  /// Fluxo:
  /// 1. Cria controller com contexto
  /// 2. Recupera ID do usuário do token JWT
  /// 3. Preenche campos iniciais com dados atuais
  /// 4. Remove estado de carregamento
  @override
  void initState() {
    super.initState();
    // Inicializa controller com contexto para feedback
    controller = EditarPerfilController(context: context);

    // Recupera ID do usuário via decodificação JWT
    controller.recuperarUsuarioId(() {
      setState(() {
        carregando = false;  // Remove loading
        // Preenche campos com dados atuais (com máscaras)
        controller.preencherCamposIniciais(
          nome: widget.nomeAtual,
          telefone: widget.telefoneAtual,
          cpf: widget.cpfAtual,
        );
      });
    });
  }

  /// DISPOSE
  ///
  /// Descrição: Libera recursos do controller quando widget é destruído.
  @override
  void dispose() {
    controller.dispose();  // Libera controllers de texto
    super.dispose();
  }

  /// BUILD
  ///
  /// Descrição: Constrói tela com AppBar, estado de carregamento e formulário.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Scaffold com estrutura completa
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar com botão de voltar e título
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),  // Volta para tela anterior
        ),
        title: const Text('Editar perfil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,           // Remove sombra
        centerTitle: false,     // Título alinhado à esquerda
      ),
      // Body condicional: loading ou formulário
      body: carregando
          ? const Center(child: CircularProgressIndicator())  // Estado de carregamento
          : EditarPerfilForm(controller: controller),         // Formulário de edição
      // Navegação inferior desabilitada
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,  // -1 = nenhuma selecionada
        enabled: false,               // Desabilitada nesta tela
        onTap: (_) {},                // Callback vazio
      ),
    );
  }

  // Fim da classe EditarPerfil
  // 
  // Tela de edição de perfil com:
  // - Dados pré-preenchidos via parâmetros
  // - Controller para gerenciar estado e validações
  // - Estado de carregamento durante inicialização
  // - Recuperação de ID via JWT
  // - AppBar com navegação de volta
  // - Navegação inferior desabilitada
}
