import 'package:flutter/material.dart';

import 'package:sudema_app/screens/widgets/navbar.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/controller/alterar_perfil_controller.dart';
import 'package:sudema_app/screens/perfil/menu/alterarperfil/form/alterar_perfil_form.dart';

class EditarPerfil extends StatefulWidget {
  final String nomeAtual;
  final String telefoneAtual;
  final String cpfAtual;

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
  final int _currentIndex = -1;
  late final EditarPerfilController controller;

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    controller = EditarPerfilController(context: context);

    controller.recuperarUsuarioId(() {
      setState(() {
        carregando = false;
        controller.preencherCamposIniciais(
          nome: widget.nomeAtual,
          telefone: widget.telefoneAtual,
          cpf: widget.cpfAtual,
        );
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Editar perfil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : EditarPerfilForm(controller: controller),
      bottomNavigationBar: NavBar(
        currentIndex: _currentIndex,
        enabled: false,
        onTap: (_) {},
      ),
    );
  }
}
