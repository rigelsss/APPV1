import 'package:flutter/material.dart';

class NovaDenunciaPage extends StatefulWidget {
  const NovaDenunciaPage({super.key});

  @override
  State<NovaDenunciaPage> createState() => _NovaDenunciaPageState();
}

class _NovaDenunciaPageState extends State<NovaDenunciaPage> {
  final List<String> opcao = [
    'Categoria',
    'Localização',
    'Identificação',
    'Denúncia'
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Denunciar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              print("Botão de notificações apertado");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Menu fixo com 4 opções
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(opcao.length, (index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        opcao[index],
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.blue[900] : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 3,
                        width: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[900] : Colors.transparent,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          // Conteúdo dinâmico baseado na seleção
          Expanded(
            child: _buildConteudoSelecionado(),
          ),
        ],
      ),
    );
  }

  Widget _buildConteudoSelecionado() {
    switch (selectedIndex) {
      case 0:
        return const Center(child: Text("Categoria de Denúncia"));
      case 1:
        return const Center(child: Text("Localização da Denúncia"));
      case 2:
        return const Center(child: Text("Identificação do Denunciante"));
      case 3:
        return const Center(child: Text("Denúncia"));
      default:
        return const SizedBox();
    }
  }
}
