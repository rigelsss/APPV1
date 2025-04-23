import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/appbar.dart';
class editarperfil extends StatefulWidget {
  const editarperfil({super.key});

  @override
  State<editarperfil> createState() => _editarperfilState();
}

class _editarperfilState extends State<editarperfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
    );
  }
}
