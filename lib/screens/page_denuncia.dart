import 'package:flutter/material.dart';
import 'package:sudema_app/screens/aba_localizacao.dart';
import '../models/denuncia_data.dart';

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
  final Set<int> _categoriasExpandidas = {};

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
      {
        'icone': Icons.pets,
        'texto': 'Contra a fauna',
        'subcategorias': [
          'Caça ilegal de animais silvestres',
          'Tráfico de animais silvestres',
          'Maus-tratos',
          'Comércio ilegal',
          'Introdução de espécies exóticas'
        ]
      },
      {
        'icone': Icons.eco,
        'texto': 'Contra a flora',
        'subcategorias': [
          'Desmatamento ilegal',
          'Queimadas não autorizadas',
          'Destruição de áreas de preservação permanentes (APPs)',
          'Uso de agrotóxicos proibidos'
        ]
      },
      {
        'icone': Icons.factory,
        'texto': 'Poluição e contaminação ambiental',
        'subcategorias': [
          'Lançamento irregular de esgoto e resíduos industriais em rios e mares',
          'Poluição do ar',
          'Contaminação do solo',
          'Ruído excessivo'
        ]
      },
      {
        'icone': Icons.park,
        'texto': 'Degradação de áreas protegidas',
        'subcategorias': [
          'Construlção irregular em áreas de preservação',
          'Supressão de vegetação em manguezais, restingas e matas ciliares',
          'Exploração irregular de recursos naturais em unidades de conservação',
          'Uso indevido de áreas costeiras e dunas'
        ]
      },
      {
        'icone': Icons.water,
        'texto': 'Recursos hídricos e balneabilidade',
        'subcategorias': [
          'Contaminação de rios, lagos e oceanos por despejo de resíduos',
          'Uso irregular de recursos hídricos',
          'Degradação de nascentes e fontes de água potável',
        ]
      },
      {
        'icone': Icons.delete,
        'texto': 'Relacionadas a resíduos sólidos',
        'subcategorias': [
          'Lixões irregulares e descarte inadequado de resíduos',
          'Não cumprimento da logística reversa de resíduos perigosos',
          'Depósito ilegal de entulho em áreas públicas e naturais',
          'Falta de tratamento adequado para resíduos hospitalares e industriais'
        ]
      },
      {
        'icone': Icons.add,
        'texto': 'Outra',
        'subcategorias': [
          'Danos a cavernas, sítios arqueológicos e áreas de valor ecológico',
          'Extração ilegal de areia, minérios e outros recursos naturais',
          'Depredação de formações rochosas, corais e outros ecossistemas sensíveis'
        ]
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Categoria da infração',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              final isExpanded = _categoriasExpandidas.contains(index);
              final selecionado = _categoriaSelecionada == categoria['texto'];
              final subcategorias = categoria['subcategorias'] as List<String>;

              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          _categoriaSelecionada = categoria['texto'] as String;
                          DenunciaData().categoria = _categoriaSelecionada;
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      leading: Icon(
                        categoria['icone'] as IconData,
                        size: 30,
                      ),
                      title: Text(
                        categoria['texto'] as String,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selecionado)
                            const Icon(Icons.check, color: Colors.green),
                          IconButton(
                            icon: Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                            onPressed: () {
                              setState(() {
                                if (isExpanded) {
                                  _categoriasExpandidas.remove(index);
                                } else {
                                  _categoriasExpandidas.add(index);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: subcategorias
                              .map(
                                (sub) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    '• $sub',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                      height: 6,
                      color: Color.fromRGBO(195, 182, 182, 1),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
