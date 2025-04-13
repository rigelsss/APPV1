import 'package:flutter/material.dart';
import 'package:sudema_app/screens/aba_localizacao.dart';

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

  String? _categoriaSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Denunciar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              print("Botão de notificações apertado");
            },
          ),
        ],
      ),
      body: Column(
        children: [
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
                          color:
                              isSelected ? Colors.blue[900] : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 3,
                        width: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue[900]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
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
        return _buildCategoriaContent();
      case 1:
        return const AbaLocalizacao();
      case 2:
        return const Center(child: Text("Identificação do Denunciante"));
      case 3:
        return const Center(child: Text("Denúncia"));
      default:
        return const SizedBox();
    }
  }

  Widget _buildCategoriaContent() {
    final categorias = [
      {'icone': Icons.pets, 'texto': 'Contra a fauna'},
      {'icone': Icons.eco, 'texto': 'Contra a flora'},
      {'icone': Icons.factory, 'texto': 'Poluição e contaminação ambiental'},
      {'icone': Icons.park, 'texto': 'Degradação de áreas protegidas'},
      {'icone': Icons.water, 'texto': 'Recursos hídricos e balneabilidade'},
      {'icone': Icons.delete, 'texto': 'Relacionadas a resíduos sólidos'},
      {'icone': Icons.add, 'texto': 'Outra'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Categoria da infração',
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold
              ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: categorias.length,
            separatorBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 1,
                color: Color.fromRGBO(195, 182, 182, 1),
              ),
            ),
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              final selecionado = _categoriaSelecionada == categoria['texto'];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                leading: Icon(
                  categoria['icone'] as IconData,
                  size: 34,
                ),
                title: Text(
                  categoria['texto'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,  
                  ),
                ),
                trailing: selecionado
                    ? const Icon(Icons.check, color: Colors.green, size: 24)
                    : null,
                onTap: () {
                  setState(() {
                    _categoriaSelecionada = categoria['texto'] as String;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
