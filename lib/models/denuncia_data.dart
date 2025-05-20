class DenunciaData {
  // Singleton
  static final DenunciaData _instance = DenunciaData._internal();
  factory DenunciaData() => _instance;
  DenunciaData._internal();

  // Dados da denúncia
  String? tipoDenunciaId;
  String? descricao;
  String? informacaoDenunciado;
  String? dataOcorrencia;
  String? referencia;
  String? imagemPath;
  bool? anonimo = false;

  // Identificação do usuário
  String? usuarioId;
  String? tokenUsuario;

  // Endereço e localização
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

  Map<String, dynamic> toJson() {
    return {
      'categoria': tipoDenunciaId,
      'descricao': descricao,
      'dataOcorrencia': dataOcorrencia,
      'referencia': referencia,
      'denunciado': informacaoDenunciado,
      'imagemPath': imagemPath,
      'anonimo': anonimo ?? false,
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
    };
  }

  void limpar() {
    tipoDenunciaId = null;
    descricao = null;
    informacaoDenunciado = null;
    dataOcorrencia = null;
    referencia = null;
    imagemPath = null;
    anonimo = false;

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
  }
}
