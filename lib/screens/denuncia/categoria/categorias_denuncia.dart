/// CATEGORIAS_DENUNCIA (NovaDenuncia)
///
/// Responsável por: Gerenciar o fluxo completo de criação de denúncias em 4 etapas.
/// Utilizado em: Controlador principal do processo de denúncia no app SUDEMA.
/// 
/// Esta tela coordena todo o fluxo de criação de denúncias ambientais:
/// 1. Identificação (anônima ou identificada)
/// 2. Categoria (tipo de infração ambiental)
/// 3. Localização (endereço e coordenadas)
/// 4. Denúncia (descrição, fotos e envio)
///
/// Utiliza um sistema de abas com validação sequencial.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/denuncia/identificacao/denuncia_identificacao.dart';
import 'package:sudema_app/screens/denuncia/denuncia/denuncia_screen.dart';
import 'package:sudema_app/screens/denuncia/localizacao/aba_localizacao.dart';
import 'package:sudema_app/screens/denuncia/categoria/widgets/categoria_content.dart';
import 'package:sudema_app/screens/denuncia/categoria/controller/categorias_controller.dart';
import 'package:sudema_app/screens/widgets/denuncia_top_bar.dart';

class NovaDenuncia extends StatefulWidget {
  const NovaDenuncia({super.key});

  @override
  State<NovaDenuncia> createState() => _NovaDenunciaState();
}

class _NovaDenunciaState extends State<NovaDenuncia> {
  // Lista das 4 etapas do fluxo de denúncia
  final List<String> opcao = ['Identificação', 'Categoria', 'Localização', 'Denúncia'];
  // Controlador que gerencia o estado e validações do fluxo
  final CategoriasController controller = CategoriasController();

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador com callback para rebuild da tela
    controller.init(() => setState(() {}));
  }

  /// _aoSelecionarAba
  ///
  /// Descrição: Gerencia navegação entre as abas do fluxo de denúncia.
  /// Parâmetros:
  /// - index: índice da aba selecionada (0-3)
  /// Retorno: void
  ///
  /// Valida se o usuário pode acessar a aba antes de navegar.
  void _aoSelecionarAba(int index) {
    // Verifica se pode navegar para a aba (validação sequencial)
    if (!controller.podeIrParaAba(index)) {
      setState(() {
        controller.definirMensagemErro(index); // Exibe mensagem de erro
      });
      return;
    }
    // Navega para a aba e limpa mensagens de erro
    setState(() {
      controller.selectedIndex = index;
      controller.mensagemErro = null;
    });
  }

  /// _irParaCategoria
  ///
  /// Descrição: Navega diretamente para a aba de seleção de categoria.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Chamado após conclusão da etapa de identificação.
  void _irParaCategoria() {
    setState(() {
      controller.selectedIndex = 1; // Índice da aba "Categoria"
      controller.mensagemErro = null;
    });
  }

  /// _irParaDenuncia
  ///
  /// Descrição: Navega diretamente para a aba final de preenchimento da denúncia.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Chamado após confirmação do endereço na etapa de localização.
  void _irParaDenuncia() {
    setState(() {
      controller.selectedIndex = 3; // Índice da aba "Denúncia"
      controller.mensagemErro = null;
    });
  }

  /// Widget NovaDenuncia
  ///
  /// Descrição: Interface principal do fluxo de denúncias com sistema de abas.
  /// Contém barra de progresso, mensagens de erro e conteúdo dinâmico.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Barra superior com as 4 etapas do fluxo
            DenunciaTopBar(
              opcoes: opcao,
              selectedIndex: controller.selectedIndex,
              podeIrParaAba: controller.podeIrParaAba, // Função de validação
              onSelecionar: _aoSelecionarAba,
            ),
            // Mensagem de erro quando navegação é inválida
            if (controller.mensagemErro != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  controller.mensagemErro!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            // Conteúdo da aba selecionada
            Expanded(child: _buildConteudoSelecionado()),
          ],
        ),
      ),
    );
  }

  /// _buildConteudoSelecionado
  ///
  /// Descrição: Constrói o widget correspondente à aba selecionada.
  /// Parâmetros: nenhum
  /// Retorno: Widget - conteúdo da etapa atual
  ///
  /// Gerencia a exibição das 4 etapas do fluxo de denúncia.
  Widget _buildConteudoSelecionado() {
    switch (controller.selectedIndex) {
      case 0: // Etapa 1: Identificação (anônima ou identificada)
        return Identificacao(onAvancar: _irParaCategoria);
      case 1: // Etapa 2: Seleção de categoria da infração
        return CategoriaContent(
          controller: controller,
          onAvancar: () => _aoSelecionarAba(2), // Vai para localização
          onRebuild: () => setState(() {}), // Callback para rebuild
        );
      case 2: // Etapa 3: Definição de localização
        return AbaLocalizacao(onEnderecoConfirmado: _irParaDenuncia);
      case 3: // Etapa 4: Preenchimento final e envio da denúncia
        return DenunciaScreen();
      default:
        return const SizedBox(); // Fallback para casos inesperados
    }
  }
}
