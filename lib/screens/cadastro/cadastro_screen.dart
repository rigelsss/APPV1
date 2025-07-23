import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets/appbar_login.dart';
import 'package:sudema_app/screens/cadastro/widgets/cadastro_form.dart';

class RegistroUser extends StatelessWidget {
  const RegistroUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDenuncia(title: 'Cadastro'),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: const CadastroForm(),
              ),
            ),
          );
        },
      ),
    );
  }
}
