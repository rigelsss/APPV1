class DenunciaData {
  static final DenunciaData _instance = DenunciaData._internal();
  factory DenunciaData() => _instance;
  DenunciaData._internal();

  String? tipoDenunciaId;
  String? descricao;
  String? informacaoDenunciado;
  String? dataOcorrencia;
  String? referencia;
  List<String> imagemPaths = [];
  bool? anonimo;

  String? usuarioEmail;
  String? usuarioId;
  String? tokenUsuario;

  double? latitude;
  double? longitude;
  String? estado;
  String? bairro;
  String? municipio;
  String? logradouro;
  String? endereco;
  bool enderecoConfirmado = false;
  String? localizacao;
  String? posicao;
  bool? categoriaConfirmada = false;
  bool identificacaoConfirmada = false;


  Map<String, dynamic> toJson() {
    return {
      'categoria': tipoDenunciaId,
      'descricao': descricao,
      'dataOcorrencia': dataOcorrencia,
      'referencia': referencia,
      'denunciado': informacaoDenunciado,
      'imagemPaths': imagemPaths,
      'anonimo': anonimo,
      'usuarioId': usuarioId,
      'tokenUsuario': tokenUsuario,
      'latitude': latitude,
      'longitude': longitude,
      'estado': estado,
      'bairro': bairro,
      'municipio': municipio,
      'logradouro': logradouro,
      'endereco': endereco,
      'enderecoConfirmado': enderecoConfirmado,
      'localizacao': localizacao,
      'posicao': posicao,
      'usuarioEmail': usuarioEmail,
      'categoriaConfirmada': categoriaConfirmada,
      'identificacaoConfirmada': identificacaoConfirmada,
    };
  }

  void limpar() {
    tipoDenunciaId = null;
    descricao = null;
    informacaoDenunciado = null;
    dataOcorrencia = null;
    referencia = null;
    imagemPaths = [];
    anonimo = null;

    latitude = null;
    longitude = null;
    estado = null;
    bairro = null;
    municipio = null;
    logradouro = null;
    endereco = null;
    enderecoConfirmado = false;

    localizacao = null;
    posicao = null;

    usuarioEmail = null;
    usuarioId = null;
    categoriaConfirmada = null;
    identificacaoConfirmada = false;
  }
}
