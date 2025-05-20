import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets_reutilizaveis/appbar.dart';
import 'package:sudema_app/screens/home_screen.dart';

class conclusao_de_denuncia extends StatefulWidget {
  const conclusao_de_denuncia({super.key});

  @override
  State<conclusao_de_denuncia> createState() => _conclusao_de_denunciaState();
}

class _conclusao_de_denunciaState extends State<conclusao_de_denuncia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Denúncia',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 64),
                decoration: BoxDecoration(
                  color: Color(0xFFD2FDE6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Denúncia realizada com sucesso',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1B8C00),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),),
                  );},
                child: const Text(
                  'Voltar para a tela inicial',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 64),
                  backgroundColor: Color(0xFF2A2F8C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
