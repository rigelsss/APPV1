import 'package:google_maps_flutter/google_maps_flutter.dart';

class DenunciaData {
  static final DenunciaData _instance = DenunciaData._internal();
  factory DenunciaData() => _instance;
  DenunciaData._internal() {
    categoria = null;
    subCategoria = null;
    localizacao = null;
    endereco = null;
    enderecoConfirmado = false;
  }

  String? subCategoria;
  String? categoria;
  LatLng? localizacao;
  String? endereco;
  bool enderecoConfirmado = false;

  void limpar() {
    categoria = null;
    subCategoria = null;
    localizacao = null;
    endereco = null;
    enderecoConfirmado = false;
  }
}

