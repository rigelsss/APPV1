import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/appbardenuncia.dart';

class RegistroPage extends StatelessWidget {
  const RegistroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDenuncia(title: 'title'),
    );
  }
}
