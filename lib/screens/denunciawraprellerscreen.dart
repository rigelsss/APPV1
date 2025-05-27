import 'package:flutter/material.dart';
import 'package:sudema_app/screens/nova_denuncia.dart';

class DenunciaWrapperScreen extends StatelessWidget {
  const DenunciaWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: NovaDenuncia(), 
    );
  }
}
