/// DENUNCIA_SCREEN
///
/// Responsável por: Etapa final do fluxo de denúncias - preenchimento de detalhes e envio.
/// Utilizado em: Quarta e última aba do processo de criação de denúncias ambientais.
/// 
/// Esta tela integra:
/// - Formulário completo com campos obrigatórios (descrição, data, denunciado)
/// - Upload de imagens como evidências da infração
/// - Confirmação de termos e condições
/// - Validação completa antes de prosseguir para revisão
/// - Integração com DenunciaController para gerenciar estado
/// - Navegação para tela de resumo final

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denuncia/denuncia/controller/denuncia_controller.dart';
import 'package:sudema_app/screens/denuncia/denuncia/widgets/upload_imagens.dart';
import 'package:sudema_app/screens/denuncia/denuncia/widgets/campos_denuncia_form.dart';
import 'package:sudema_app/screens/denuncia/denuncia/widgets/confirmacao_termos.dart';
import 'package:sudema_app/screens/denuncia/resumo/denuncia_resumo.dart';

class DenunciaScreen extends StatefulWidget {
  const DenunciaScreen({super.key});

  @override
  State<DenunciaScreen> createState() => _DenunciaScreenState();
}

class _DenunciaScreenState extends State<DenunciaScreen> {
  // Controlador que gerencia estado e validações da denúncia
  final controller = DenunciaController();

  @override
  void initState() {
    super.initState();
    // Configura listener para validação de data quando campo perde foco
    controller.dataFocus.addListener(() {
      if (!controller.dataFocus.hasFocus) {
        setState(() {
          controller.exibirErroData = true;
          controller.dataValida = controller.validarData(controller.dataController.text);
        });
      }
    });
    // Garante que token de autenticação está disponível
    controller.garantirToken();
  }

  @override
  void dispose() {
    // Libera recursos do controlador
    controller.dispose();
    super.dispose();
  }

  /// _mostrarFlushErro
  ///
  /// Descrição: Exibe mensagem de erro quando validação falha.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Mostra Flushbar com feedback sobre campos obrigatórios não preenchidos.
  void _mostrarFlushErro() {
    Flushbar(
      message: 'Preencha todos os campos obrigatórios corretamente e confirme a declaração.',
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.cancel_outlined, color: Colors.white),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  /// Widget DenunciaScreen
  ///
  /// Descrição: Interface final do fluxo de denúncias com formulário completo.
  /// Integra todos os widgets necessários para preenchimento e validação.
  @override
  Widget build(BuildContext context) {
    final dados = DenunciaData();
    // Define texto do cabeçalho baseado no tipo de denúncia
    final textoDireita = (dados.anonimo ?? false)
        ? 'Denúncia anônima'
        : (dados.usuarioEmail ?? '');

    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho com título e tipo de denúncia
              Row(
                children: [
                  Expanded(
                    child: Text('Denúncia', style: GoogleFonts.lato(fontSize: 24)),
                  ),
                  Text(
                    textoDireita,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Formulário com campos obrigatórios
              CamposDenunciaForm(controller: controller, onUpdate: () => setState(() {})),
              const SizedBox(height: 24),
              
              // Seção de upload de imagens
              Text('Adicionar arquivos', style: GoogleFonts.lato(fontSize: 16)),
              const SizedBox(height: 10),
              UploadImagensWidget(imagens: controller.imagens, onAdicionar: () async {
                await controller.adicionarImagens();
                setState(() {}); // Atualiza interface após adicionar imagens
              }),
              const SizedBox(height: 24),
              
              // Checkbox de confirmação de termos
              ConfirmacaoTermos(
                confirmacao: controller.confirmacao,
                erroConfirmacao: controller.erroConfirmacao,
                onChanged: (value) {
                  setState(() {
                    controller.confirmacao = value;
                    controller.erroConfirmacao = false; // Limpa erro ao confirmar
                  });
                },
              ),
              const SizedBox(height: 20),
              
              // Botão para revisar informações
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                onPressed: () {
                  // Valida todos os campos antes de prosseguir
                  final valido = controller.validarCampos();
                  setState(() {}); // Atualiza interface para mostrar erros

                  if (valido) {
                    // Salva dados no modelo global e navega para revisão
                    controller.salvarEmDenunciaData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ResumoDenunciaScreen()),
                    );
                  } else {
                    // Mostra mensagem de erro se validação falhar
                    _mostrarFlushErro();
                  }
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B8C00), // Verde SUDEMA
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Revisar informações',
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}
