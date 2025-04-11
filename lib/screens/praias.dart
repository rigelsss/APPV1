import 'package:flutter/material.dart';
import '../screens/widgets_reutilizaveis/appbar.dart';

class PraiasPage extends StatelessWidget {
  const PraiasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: const Center(
        child: Text('PRAIAS'),
      ),
    );
  }
}
