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
  String? _subcategoriaSelecionada;
  final Set<int> _categoriasExpandidas = {};
  final TextEditingController _outraController = TextEditingController();

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
                    if (index == 1 && _categoriaSelecionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor, selecione uma categoria antes de prosseguir.',
                          ),
                        ),
                      );
                      return;
                    }
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
        'imagem': 'assets/images/fauna.png',
        'texto': 'Contra a fauna',
        'subcategorias': [
          'Caça ilegal de animais silvestres',
          'Tráfico de animais silvestres',
          'Maus-tratos a animais',
          'Comércio ilegal de espécies protegidas',
          'Introdução de espécies exóticas invasoras'
        ]
      },
      {
        'imagem': 'assets/images/flora.png',
        'texto': 'Contra a flora',
        'subcategorias': [
          'Desmatamento ilegal',
          'Queimadas não autorizadas',
          'Destruição de áreas de preservação permanentes (APPs)',
          'Uso de agrotóxicos proibidos'
        ]
      },
      {
        'imagem': 'assets/images/poluicao.png',
        'texto': 'Poluição e contaminação ambiental',
        'subcategorias': [
          'Lançamento irregular de esgoto e resíduos industriais em rios e mares',
          'Poluição do ar',
          'Contaminação do solo',
          'Ruído excessivo'
        ]
      },
      {
        'imagem': 'assets/images/areas_protegidas.png',
        'texto': 'Degradação de áreas protegidas',
        'subcategorias': [
          'Construlção irregular em áreas de preservação',
          'Supressão de vegetação em manguezais, restingas e matas ciliares',
          'Exploração irregular de recursos naturais em unidades de conservação',
          'Uso indevido de áreas costeiras e dunas'
        ]
      },
      {
        'imagem': 'assets/images/recursosHidricos.png',
        'texto': 'Recursos hídricos e balneabilidade',
        'subcategorias': [
          'Contaminação de rios, lagos e oceanos por despejo de resíduos',
          'Uso irregular de recursos hídricos',
          'Degradação de nascentes e fontes de água potável',
        ]
      },
      {
        'imagem': 'assets/images/residuos.png',
        'texto': 'Relacionadas a resíduos sólidos',
        'subcategorias': [
          'Lixões irregulares e descarte inadequado de resíduos',
          'Não cumprimento da logística reversa de resíduos perigosos',
          'Depósito ilegal de entulho em áreas públicas e naturais',
          'Falta de tratamento adequado para resíduos hospitalares e industriais'
        ]
      },
      {
        'imagem': 'assets/images/outra.png',
        'texto': 'Outra',
        'subcategorias': []
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
              final isOutraCategoria = categoria['texto'] == 'Outra';

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
                          _subcategoriaSelecionada = null;
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Image.asset(
                            categoria['imagem'] as String,
                            fit: BoxFit.cover,
                          ),
                        ),
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
                          if (selecionado) const Icon(Icons.check, color: Colors.green),
                          IconButton(
                            icon: Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: isOutraCategoria
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: TextField(
                                      controller: _outraController,
                                      decoration: InputDecoration(
                                        hintText: 'Especifique',
                                        hintStyle: TextStyle(color: Colors.grey.shade400),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFB9CD23),
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          elevation: 0,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _subcategoriaSelecionada = _outraController.text;
                                            DenunciaData().subCategoria = _outraController.text;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text("Descrição registrada com sucesso!"),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Confirmar',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (categoria['subcategorias'] as List<String>).map(
                                  (sub) {
                                    final isSelected = _subcategoriaSelecionada == sub;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _subcategoriaSelecionada = sub;
                                          DenunciaData().subCategoria = sub;
                                        });
                                      },
                                      child: Container(
                                        height: 48,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.blue[700]
                                              : const Color(0xFFB9CD23),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          sub,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
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
