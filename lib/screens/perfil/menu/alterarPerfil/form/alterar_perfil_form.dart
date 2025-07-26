/// ALTERAR_PERFIL_FORM
///
/// Responsável por: Formulário de edição de perfil com 3 campos (nome, CPF, telefone),
/// validações específicas, máscaras de entrada e botão de salvar.
/// Utilizado em: EditarPerfil como formulário principal de edição.

import 'package:flutter/material.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/controller/alterar_perfil_controller.dart';
import 'package:sudema_app/utils/validarCPF.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/utils/alterar_perfil_validadores.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_page.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/widgets/alterar_perfil_widget_decoration.dart';

/// Widget EditarPerfilForm
///
/// Descrição: Formulário stateless com validações, máscaras e navegação
/// após sucesso, usando controller injetado para gerenciar estado.
class EditarPerfilForm extends StatelessWidget {
  final EditarPerfilController controller;  // Controller injetado

  const EditarPerfilForm({super.key, required this.controller});

  /// BUILD
  ///
  /// Descrição: Constrói formulário com 3 campos, validações e botão de salvar.
  /// Parâmetros:
  /// - context: Contexto do widget para navegação
  /// Retorno: Widget Form com scroll e campos organizados
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,  // Chave para validação do formulário
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),  // Padding uniforme
        child: Column(
          children: [
            // Campo 1: Nome completo
            buildLabeledField(
              label: 'Nome completo',
              controller: controller.nomeController,  // Controller do nome
              validator: validarNome,                 // Validação de nome
            ),
            const SizedBox(height: 20),  // Espaçamento entre campos
            
            // Campo 2: CPF com máscara
            buildLabeledField(
              label: 'CPF',
              controller: controller.cpfController,   // Controller do CPF
              inputFormatters: [controller.cpfMask],  // Máscara XXX.XXX.XXX-XX
              keyboardType: TextInputType.number,     // Teclado numérico
              // Validação: usa função utilitária validarCPF
              validator: (value) =>
                  value == null || !validarCPF(value) ? 'CPF inválido.' : null,
            ),
            const SizedBox(height: 20),
            
            // Campo 3: Telefone com máscara
            buildLabeledField(
              label: 'Telefone para contato',
              controller: controller.telefoneController,  // Controller do telefone
              inputFormatters: [controller.telMask],      // Máscara (XX) XXXXX-XXXX
              keyboardType: TextInputType.phone,          // Teclado de telefone
              validator: validarTelefone,                 // Validação de telefone
            ),
            const SizedBox(height: 40),  // Espaçamento maior antes do botão
            
            // Botão de salvar alterações
            SizedBox(
              width: double.infinity,  // Ocupa toda largura disponível
              child: ElevatedButton(
                onPressed: () {
                  // Chama controller para salvar dados com callbacks
                  controller.salvarDados(
                    // Callback de sucesso: navega para perfil atualizado
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Perfiluser(token: controller.token),
                      ),
                    ),
                    // Callback de falha: vazio (controller já exibe erro)
                    () {}, 
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B8C00),  // Verde (sucesso)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),  // Bordas arredondadas
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),  // Padding vertical
                ),
                child: const Text(
                  'Salvar alterações',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fim da classe EditarPerfilForm
  // 
  // Formulário de edição de perfil com:
  // - 3 campos com validações específicas
  // - Máscaras automáticas para CPF e telefone
  // - Validação de CPF via algoritmo
  // - Botão de salvar com callbacks de sucesso/falha
  // - Navegação para perfil após sucesso
  // - Layout scrollável com espaçamentos consistentes
}
