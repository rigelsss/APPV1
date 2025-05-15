import 'package:flutter/material.dart';
import 'package:sudema_app/screens/widgets/appbar.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final paddingHorizontal = isWide ? constraints.maxWidth * 0.2 : 16.0;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Denúncias',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD2FDE6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF1B8C00),
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'Denúncia realizada com sucesso!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF1B8C00),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWide ? 300 : double.infinity,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 100),
                          backgroundColor: const Color(0xFF2A2F8C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Voltar à página inicial!',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
