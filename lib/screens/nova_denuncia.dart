import 'package:flutter/material.dart';
import 'package:sudema_app/screens/identificacao_screen.dart';
import 'package:sudema_app/screens/denuncia_screen.dart';
import 'package:sudema_app/services/categoria_service.dart';
import 'package:sudema_app/screens/aba_localizacao.dart';
import 'package:sudema_app/screens/widgets/categoria_selector.dart';
import 'package:sudema_app/screens/widgets/denuncia_top_bar.dart';
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

  final Map<int, String> iconesPorCategoria = {
    1: 'assets/images/fauna.png',
    2: 'assets/images/flora.png',
    3: 'assets/images/poluicao.png',
    4: 'assets/images/areas_protegidas.png',
    5: 'assets/images/residuos.png',
    6: 'assets/images/recursoshidricos.png',
    7: 'assets/images/outra.png',
  };

  @override
  void initState() {
    super.initState();
    DenunciaData().limpar();
    _carregarCategorias();
  }

  Future<void> _carregarCategorias() async {
    try {
      final resultado = await CategoriaService.buscarCategoriasComTipos();
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
      return _categoriaSelecionada != null && _subcategoriaSelecionada?.isNotEmpty == true;
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
          DenunciaTopBar(
            opcoes: opcao,
            selectedIndex: selectedIndex,
            podeIrParaAba: _podeIrParaAba,
            onSelecionar: _aoSelecionarAba,
          ),
          if (_mensagemErro != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _mensagemErro!,
                style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          Expanded(child: _buildConteudoSelecionado()),
        ],
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
        return DenunciaScreen();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCategoriaContent() {
    if (_isLoadingCategorias) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Categoria da infração', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: CategoriaSelector(
            categorias: categorias,
            iconesPorCategoria: iconesPorCategoria,
            categoriaSelecionada: _categoriaSelecionada,
            subcategoriaSelecionada: _subcategoriaSelecionada,
            categoriasExpandidas: _categoriasExpandidas,
            onCategoriaSelecionada: (texto) {
              setState(() {
                _categoriaSelecionada = texto;
                _subcategoriaSelecionada = null;
                _mensagemErro = null;
              });
            },
            onSubcategoriaSelecionada: (nome, id, texto) {
              setState(() {
                _subcategoriaSelecionada = nome;
                _categoriaSelecionada = texto; // Corrigido aqui
                DenunciaData().tipoDenunciaId = id.toString();
                _mensagemErro = null;
                print('>> tipoDenunciaId salvo em DenunciaData: \${DenunciaData().tipoDenunciaId}');
              });
            },
            onToggleExpand: (index) {
              setState(() {
                if (_categoriasExpandidas.contains(index)) {
                  _categoriasExpandidas.remove(index);
                } else {
                  _categoriasExpandidas.add(index);
                }
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2F8C),
              disabledBackgroundColor: Colors.grey[500],
              minimumSize: const Size.fromHeight(52.8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: (_categoriaSelecionada != null &&
                    _subcategoriaSelecionada != null &&
                    _subcategoriaSelecionada!.isNotEmpty)
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