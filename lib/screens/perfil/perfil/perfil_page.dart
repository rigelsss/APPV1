/// PERFIL_PAGE
///
/// Responsável por: Tela principal do perfil do usuário com informações pessoais,
/// menu de opções (editar perfil, alterar senha, etc.) e botões de ação.
/// Utilizado em: Acesso via navegação principal ou drawer para gerenciar conta do usuário.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/perfil/perfil/controller/perfil_controller.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_appbar.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_user_infocard.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_menu_list.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_footer_botoes.dart';

/// Widget Perfiluser
///
/// Descrição: Tela completa de perfil com carregamento de dados do usuário,
/// tratamento de erros e navegação para funcionalidades de edição.
class Perfiluser extends StatefulWidget {
  final String? token;  // Token JWT para autenticação (opcional)
  //final PerfilController? controller; // Controller opcional (comentado)

  const Perfiluser({super.key, this.token,});

  @override
  PerfiluserState createState() => PerfiluserState();
}

class PerfiluserState extends State<Perfiluser> {
  final controller = PerfilController();  // Controller para gerenciar dados do perfil
  //late final PerfilController controller; // Versão alternativa (comentada)
  int _currentIndex = -1;  // Índice da navegação inferior (-1 = nenhuma selecionada)

  /// INITSTATE
  ///
  /// Descrição: Inicializa controller, adiciona listener e prepara token para carregamento.
  @override
  void initState() {
    super.initState();
    //controller = widget.controller ?? PerfilController(); // Versão alternativa
    controller.addListener(_updateState);  // Escuta mudanças no controller
    controller.prepararToken(tokenExterno: widget.token);  // Configura token e carrega dados
  }

  /// DISPOSE
  ///
  /// Descrição: Remove listener e libera recursos do controller.
  @override
  void dispose() {
    controller.removeListener(_updateState);  // Remove listener
    controller.dispose();  // Libera recursos do controller
    super.dispose();
  }

  /// _UPDATESTATE
  ///
  /// Descrição: Callback executado quando controller notifica mudanças.
  /// Atualiza UI apenas se widget ainda está montado.
  void _updateState() {
    if (mounted) {
      setState(() {});  // Força rebuild da UI
    }
  }

  /// _HANDLESENHALTERADA
  ///
  /// Descrição: Callback executado após alteração de senha bem-sucedida.
  /// Parâmetros:
  /// - novoToken: Novo token JWT após alteração de senha
  /// Retorno: void
  void _handleSenhaAlterada(String novoToken) {
    controller.token = novoToken;        // Atualiza token no controller
    controller.isLoading = true;         // Ativa estado de carregamento
    controller.errorFetching = false;    // Limpa erros anteriores
    controller.carregarDadosUsuario();   // Recarrega dados com novo token
  }

  /// BUILD
  ///
  /// Descrição: Constrói tela de perfil com diferentes estados (loading, erro, sucesso).
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Scaffold com estrutura completa da tela
  @override
  Widget build(BuildContext context) {
    // Exibe diálogo de erro se houver erro de carregamento
    if (controller.errorFetching && controller.errorMessage.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        _showErrorDialog(context, controller.errorMessage);
      });
    }

    return Scaffold(
      // AppBar personalizada com nome do usuário
      appBar: PerfilHeader(nome: controller.userData['name']),
      backgroundColor: Colors.white,
      // Body com diferentes estados baseados no controller
      body: Builder(
        builder: (context) {
          if (controller.isLoading) {
            // Estado 1: Carregando dados
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorFetching) {
            // Estado 2: Erro no carregamento
            return Center(child: Text('Erro ao carregar perfil: ${controller.errorMessage}'));
          } else if (controller.userData.isEmpty) {
            // Estado 3: Dados vazios
            return const Center(child: Text('Nenhuma informação de usuário encontrada'));
          } else {
            // Estado 4: Sucesso - exibe perfil completo
            return _buildPerfil(context);
          }
        },
      ),
      // Barra de navegação inferior
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,  // Índice atual (-1 = nenhuma selecionada)
        enabled: true,                // Navegação habilitada
        onTap: (index) {
          setState(() {
            _currentIndex = index;  // Atualiza índice selecionado
          });
          // Navegação baseada no índice
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');          // Home
              break;
            case 1:
              Navigator.pushNamed(context, '/denuncias');     // Denúncias
              break;
            case 2:
              Navigator.pushNamed(context, '/balneabilidade'); // Balneabilidade
              break;
            case 3:
              Navigator.pushNamed(context, '/noticias');      // Notícias
              break;
          }
        },
      ),
    );
  }

  /// _BUILDPERFIL
  ///
  /// Descrição: Constrói layout do perfil com card de informações, menu e botões.
  /// Parâmetros:
  /// - context: Contexto do widget
  /// Retorno: Widget Padding com estrutura completa do perfil
  Widget _buildPerfil(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Card com informações do usuário (nome, email, telefone, CPF)
          PerfilInfoCard(userData: controller.userData),
          const SizedBox(height: 20),
          // Menu de opções (notificações, editar perfil, alterar senha, etc.)
          Expanded(
            child: PerfilMenuList(
              token: controller.token,
              userData: controller.userData,
              onSenhaAlterada: _handleSenhaAlterada,  // Callback para senha alterada
            ),
          ),
          // Botões de ação (logout, etc.)
          PerfilFooterButtons(onLogout: () => controller.logout(context)),
        ],
      ),
    );
  }

  /// _SHOWERRORDIALOG
  ///
  /// Descrição: Exibe diálogo de erro quando falha ao carregar dados do usuário.
  /// Parâmetros:
  /// - context: Contexto para exibir diálogo
  /// - message: Mensagem de erro a ser exibida
  /// Retorno: void
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text("Erro ao buscar dados do usuário: $message"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);  // Fecha diálogo
              Navigator.pop(context);  // Volta para tela anterior
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Fim da classe PerfiluserState
  // 
  // Tela de perfil do usuário com:
  // - Carregamento de dados via controller
  // - Estados de loading, erro e sucesso
  // - Card de informações pessoais
  // - Menu de opções de edição
  // - Botões de ação (logout)
  // - Navegação inferior integrada
}
