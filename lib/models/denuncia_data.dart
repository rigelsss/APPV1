import 'package:google_maps_flutter/google_maps_flutter.dart';

class DenunciaData {
  static final DenunciaData _instance = DenunciaData._internal();
  factory DenunciaData() => _instance;

  DenunciaData._internal() {
    limpar();
  }
  String? categoria;
  String? subCategoria;
  LatLng? localizacao;
  String? endereco;
  bool enderecoConfirmado = false;
  String? tokenUsuario; 
  String? dataOcorrencia;
  String? descricao;
  String? referencia;
  String? denunciado;
  String? imagemPath; 





  void limpar() {
    categoria = null;
    subCategoria = null;
    localizacao = null;
    endereco = null;
    enderecoConfirmado = false;

    tokenUsuario = null;

    dataOcorrencia = null;
    descricao = null;
    referencia = null;
    denunciado = null;
    imagemPath = null;
  }
}
