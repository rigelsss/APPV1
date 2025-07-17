import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denuncia/categoria/service/categoria_service.dart';

class CategoriasController {
  int selectedIndex = 0;
  String? categoriaSelecionada;
  String? subcategoriaSelecionada;
  final Set<int> categoriasExpandidas = {};
  List<dynamic> categorias = [];
  bool isLoadingCategorias = true;
  String? mensagemErro;
  String? _token;

  final Map<int, String> iconesPorCategoria = {
    1: 'assets/images/fauna.png',
    2: 'assets/images/flora.png',
    3: 'assets/images/poluicao.png',
    4: 'assets/images/areas_protegidas.png',
    5: 'assets/images/residuos.png',
    6: 'assets/images/recursoshidricos.png',
    7: 'assets/images/outra.png',
  };

  Future<void> init(Function() onUpdate) async {
    DenunciaData().limpar();
    await carregarToken();
    await carregarCategorias();
    onUpdate();
  }

  Future<void> carregarToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
    }
  }

  bool get isLoggedIn {
    if (_token == null) return false;
    try {
      return !JwtDecoder.isExpired(_token!);
    } catch (_) {
      return false;
    }
  }

  Future<void> carregarCategorias() async {
    try {
      categorias = await CategoriaService.buscarCategoriasComTipos();
      isLoadingCategorias = false;
    } catch (e) {
      isLoadingCategorias = false;
    }
  }

  bool podeIrParaAba(int index) {
    switch (index) {
      case 0:
        return true;
      case 1:
        return DenunciaData().identificacaoConfirmada == true || DenunciaData().categoriaConfirmada == true;
      case 2:
        return DenunciaData().categoriaConfirmada == true;
      case 3:
        return DenunciaData().enderecoConfirmado == true;
      default:
        return false;
    }
  }

  void definirMensagemErro(int index) {
    switch (index) {
      case 1:
        mensagemErro = 'Preencha os dados de identificação antes de continuar.';
        break;
      case 2:
        mensagemErro = 'Selecione uma categoria e subcategoria antes de continuar.';
        break;
      case 3:
        mensagemErro = 'Confirme o endereço antes de continuar.';
        break;
    }
  }

  void selecionarCategoria(String texto) {
    categoriaSelecionada = texto;
    subcategoriaSelecionada = null;
    mensagemErro = null;
  }

  void selecionarSubcategoria(String nome, int id, String texto) {
    subcategoriaSelecionada = nome;
    categoriaSelecionada = texto;
    DenunciaData().tipoDenunciaId = id.toString();
    DenunciaData().usuarioEmail = isLoggedIn ? JwtDecoder.decode(_token!)['email'] : null;
    DenunciaData().categoriaConfirmada = true;
    DenunciaData().nomeCategoriaSelecionada = categoriaSelecionada;
    DenunciaData().nomeSubcategoriaSelecionada = subcategoriaSelecionada;
    mensagemErro = null;
  }

  void alternarExpansaoCategoria(int index) {
    if (categoriasExpandidas.contains(index)) {
      categoriasExpandidas.remove(index);
    } else {
      categoriasExpandidas.add(index);
    }
  }
}
