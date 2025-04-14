import 'package:google_maps_flutter/google_maps_flutter.dart';

class DenunciaData {
  static final DenunciaData _instance = DenunciaData._internal();
  factory DenunciaData() => _instance;
  DenunciaData._internal() {
    categoria = null;
    localizacao = null;
    endereco = null;
  }

  String? categoria;
  LatLng? localizacao;
  String? endereco;

  void limpar() {
    categoria = null;
    localizacao = null;
    endereco = null;
  }
}
