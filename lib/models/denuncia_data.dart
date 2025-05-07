class DenunciaData {
  static final DenunciaData _instance = DenunciaData._internal();

  factory DenunciaData() {
    return _instance;
  }

  DenunciaData._internal();

  String? tipoDenunciaId;
  String? descricao;
  String? usuarioId;
  double? latitude;
  double? longitude;
  String? endereco;
  bool enderecoConfirmado = false;
  String? tokenUsuario; 
  String? estado;
  String? bairro;
  String? municipio;
  String? logradouro;
  String? dataOcorrencia;
  String? referencia;
  String? informacaoDenunciado;
  String? imagemPath; 
  bool? anonimo = false;
  String? localizacao;
  String? posicao;

  Map<String, dynamic> toJson() {
  return {
    'categoria': tipoDenunciaId,
    'latitude': latitude,
    'longitude': longitude,
    'endereco': endereco,
    'enderecoConfirmado': enderecoConfirmado,
    'tokenUsuario': tokenUsuario,
    'dataOcorrencia': dataOcorrencia,
    'descricao': descricao,
    'referencia': referencia,
    'denunciado': informacaoDenunciado,
    'imagemPath': imagemPath,
    'anonimo': false,
    'localizacao': localizacao,
    'posicao': posicao,
    };
  }



  void limpar() {
    tipoDenunciaId = null;
    descricao = null;
    latitude = null;
    longitude = null;
    endereco = null;
    enderecoConfirmado = false;

    tokenUsuario = null;

    dataOcorrencia = null;
    descricao = null;
    referencia = null;
    informacaoDenunciado = null;
    imagemPath = null;

    anonimo = null;
    posicao = null;
  }
}
