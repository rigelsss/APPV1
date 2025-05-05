import 'package:flutter/material.dart';
import 'package:sudema_app/screens/Identificacao.dart';
import 'package:sudema_app/screens/denuncia.dart';
import 'package:sudema_app/services/categoria_service.dart';
import 'package:sudema_app/screens/aba_localizacao.dart';
import '../models/denuncia_data.dart';

class NovaDenuncia extends StatefulWidget {
  const NovaDenuncia({super.key});

  @override
  State<NovaDenuncia> createState() => _NovaDenunciaState();
}

class _NovaDenunciaState extends State<NovaDenuncia> {
  final List<String> opcao = ['Categoria', 'Localização', 'Identificação', 'Denúncia'];

  int selectedIndex = 0;
  String? _categoriaSelecionada;
  String? _subcategoriaSelecionada;
  final Set<int> _categoriasExpandidas = {};

  List<dynamic> categorias = [];
  bool _isLoadingCategorias = true;

  String? _mensagemErro;

  @override
  void initState() {
    super.initState();
    DenunciaData().limpar();
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    try {
      final resultado = await CategoriaService.buscarCategorias();
      setState(() {
        categorias = resultado;
        _isLoadingCategorias = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategorias = false;
      });
    }
  }

  bool _podeIrParaAba(int index) {
    if (index == 1) {
      return _categoriaSelecionada != null && _subcategoriaSelecionada != null && _subcategoriaSelecionada!.isNotEmpty;
    } else if (index == 2 || index == 3) {
      return DenunciaData().enderecoConfirmado == true;
    }
    return true;
  }

  void _aoSelecionarAba(int index) {
    if (!_podeIrParaAba(index)) {
      setState(() {
        if (index == 1) {
          _mensagemErro = 'Selecione uma categoria e subcategoria antes de continuar.';
        } else {
          _mensagemErro = 'Confirme o endereço antes de continuar.';
        }
      });
      return;
    }
    setState(() {
      selectedIndex = index;
      _mensagemErro = null;
    });
  }

  void _irParaIdentificacao() {
    setState(() {
      selectedIndex = 2;
      _mensagemErro = null;
    });
  }

  void _irParaDenuncia() {
    setState(() {
      selectedIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Denunciar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopBar(),
          if (_mensagemErro != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _mensagemErro!,
                style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          Expanded(
            child: _buildConteudoSelecionado(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(opcao.length, (index) {
          final isSelected = index == selectedIndex;
          final isEnabled = _podeIrParaAba(index);
          return GestureDetector(
            onTap: () => _aoSelecionarAba(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  opcao[index],
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? Colors.blue[900]
                        : isEnabled
                            ? Colors.grey[700]
                            : Colors.grey[400],
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
    );
  }

  Widget _buildConteudoSelecionado() {
    switch (selectedIndex) {
      case 0:
        return _buildCategoriaContent();
      case 1:
        return AbaLocalizacao(onEnderecoConfirmado: _irParaIdentificacao);
      case 2:
        return Identificacao(onProsseguir: _irParaDenuncia);
      case 3:
        return  DenunciaScreen();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCategoriaContent() {
    if (_isLoadingCategorias) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categorias.isEmpty) {
      return const Center(child: Text('Nenhuma categoria disponível.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Categoria da infração', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final categoria = categorias[index];
              final String texto = categoria['nome'] ?? 'Sem texto';
              final String imagem = categoria['imagem'] ?? 'assets/images/image-break.png';
              final List<dynamic> subcategorias = categoria['subcategorias'] ?? [];
              final isExpanded = _categoriasExpandidas.contains(index);
              final selecionado = _categoriaSelecionada == texto;

              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          _categoriaSelecionada = texto;
                          DenunciaData().categoria = texto;
                          _subcategoriaSelecionada = null;
                          _mensagemErro = null;
                        });
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Image.asset(
                            imagem,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/image-break.png', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      title: Text(texto, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (selecionado) const Icon(Icons.check, color: Colors.green),
                          IconButton(
                            icon: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: subcategorias.map((sub) {
                            final isSelected = _subcategoriaSelecionada == sub;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _subcategoriaSelecionada = sub;
                                  _categoriaSelecionada = texto;
                                  DenunciaData().categoria = texto;
                                  DenunciaData().subCategoria = sub;
                                  _mensagemErro = null;
                                });
                              },
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF1B8C00) : const Color(0xFFB9CD23),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  sub,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected ? Colors.white : Colors.black87,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    const Divider(indent: 20, endIndent: 20, height: 6, color: Color.fromRGBO(195, 182, 182, 1)),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2F8C),
              minimumSize: const Size.fromHeight(52.8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: (_categoriaSelecionada != null && _subcategoriaSelecionada != null && _subcategoriaSelecionada!.isNotEmpty)
                ? () => _aoSelecionarAba(1)
                : null,
            child: const Center(
              child: Text(
                'Selecionar Categoria',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
