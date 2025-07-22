import 'package:flutter/material.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/controller/alterar_perfil_controller.dart';
import 'package:sudema_app/utils/validarCPF.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/utils/alterar_perfil_validadores.dart';
import 'package:sudema_app/screens/perfil/perfil/perfil_page.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/widgets/alterar_perfil_widget_decoration.dart';

class EditarPerfilForm extends StatelessWidget {
  final EditarPerfilController controller;

  const EditarPerfilForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            buildLabeledField(
              label: 'Nome completo',
              controller: controller.nomeController,
              validator: validarNome,
            ),
            const SizedBox(height: 20),
            buildLabeledField(
              label: 'CPF',
              controller: controller.cpfController,
              inputFormatters: [controller.cpfMask],
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || !validarCPF(value) ? 'CPF inválido.' : null,
            ),
            const SizedBox(height: 20),
            buildLabeledField(
              label: 'Telefone para contato',
              controller: controller.telefoneController,
              inputFormatters: [controller.telMask],
              keyboardType: TextInputType.phone,
              validator: validarTelefone,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.salvarDados(
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Perfiluser(token: controller.token),
                      ),
                    ),
                    () {}, 
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B8C00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
}
