/// DENUNCIA_DATA
///
/// Responsável por: Singleton para armazenar dados da denúncia durante o fluxo
/// de criação, mantendo estado entre diferentes telas.
/// Utilizado em: Sistema de denúncias para persistência temporária de dados.

/// Classe DenunciaData
///
/// Descrição: Singleton que mantém dados da denúncia durante o fluxo de criação.
/// Padrão: Singleton para garantir única instância global.
class DenunciaData {
  // Implementação do padrão Singleton
  static final DenunciaData _instance = DenunciaData._internal();  // Instância única
  factory DenunciaData() => _instance;                             // Factory retorna instância
  DenunciaData._internal();                                        // Construtor privado

  // Dados de identificação
  bool? anonimo;  // Se a denúncia é anônima ou identificada

  // Dados de categoria
  String? tipoDenunciaId;              // ID da categoria selecionada
  String? nomeCategoriaSelecionada;    // Nome da categoria para exibição
  String? nomeSubcategoriaSelecionada; // Nome da subcategoria para exibição

  // Dados da ocorrência
  String? dataOcorrencia;        // Data quando ocorreu a infração
  String? descricao;             // Descrição detalhada da denúncia
  String? referencia;            // Ponto de referência do local
  String? informacaoDenunciado;  // Informações sobre o denunciado
  List<String> imagemPaths = []; // Caminhos das imagens anexadas

  // Dados do usuário
  String? usuarioEmail;  // E-mail do usuário logado
  String? usuarioId;     // ID do usuário no sistema
  String? tokenUsuario;  // Token JWT para autenticação

  // Dados de localização
  double? latitude;              // Coordenada de latitude
  double? longitude;             // Coordenada de longitude
  String? estado;                // Estado (Paraíba)
  String? bairro;                // Bairro da ocorrência
  String? municipio;             // Município da ocorrência
  String? logradouro;            // Logradouro (rua, avenida)
  String? endereco;              // Endereço completo formatado
  bool enderecoConfirmado = false; // Se o endereço foi confirmado pelo usuário
  String? localizacao;           // Descrição da localização
  String? posicao;               // Posição adicional
  
  // Estados de confirmação do fluxo
  bool? categoriaConfirmada = false;      // Se categoria foi confirmada
  bool identificacaoConfirmada = false;   // Se identificação foi confirmada


  /// TOJSON
  ///
  /// Descrição: Converte todos os dados da denúncia para Map para envio à API.
  /// Parâmetros: nenhum
  /// Retorno: Map<String, dynamic> com todos os dados
  ///
  /// Usado para serializar dados antes do envio para API SUDEMA.
  Map<String, dynamic> toJson() {
    return {
      // Dados da categoria
      'categoria': tipoDenunciaId,                           // ID da categoria
      'nomeCategoriaSelecionada': nomeCategoriaSelecionada,  // Nome para exibição
      'nomeSubcategoriaSelecionada': nomeSubcategoriaSelecionada, // Subcategoria
      
      // Dados da ocorrência
      'descricao': descricao,                    // Descrição detalhada
      'dataOcorrencia': dataOcorrencia,          // Data da ocorrência
      'referencia': referencia,                  // Ponto de referência
      'denunciado': informacaoDenunciado,        // Info do denunciado
      'imagemPaths': imagemPaths,                // Caminhos das imagens
      
      // Dados de identificação
      'anonimo': anonimo,                        // Se é anônima
      'usuarioId': usuarioId,                    // ID do usuário
      'usuarioEmail': usuarioEmail,              // E-mail do usuário
      'tokenUsuario': tokenUsuario,              // Token de autenticação
      
      // Dados de localização
      'latitude': latitude,                      // Coordenada lat
      'longitude': longitude,                    // Coordenada lng
      'estado': estado,                          // Estado
      'bairro': bairro,                          // Bairro
      'municipio': municipio,                    // Município
      'logradouro': logradouro,                  // Logradouro
      'endereco': endereco,                      // Endereço completo
      'localizacao': localizacao,                // Descrição da localização
      'posicao': posicao,                        // Posição adicional
      
      // Estados de confirmação
      'enderecoConfirmado': enderecoConfirmado,           // Endereço confirmado
      'categoriaConfirmada': categoriaConfirmada,         // Categoria confirmada
      'identificacaoConfirmada': identificacaoConfirmada, // Identificação confirmada
    };
  }

  /// LIMPAR
  ///
  /// Descrição: Reseta todos os dados da denúncia para estado inicial.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Usado após envio da denúncia ou cancelamento do fluxo.
  void limpar() {
    // Limpa dados da categoria
    tipoDenunciaId = null;
    nomeCategoriaSelecionada = null;
    nomeSubcategoriaSelecionada = null;
    
    // Limpa dados da ocorrência
    descricao = null;
    informacaoDenunciado = null;
    dataOcorrencia = null;
    referencia = null;
    imagemPaths = [];  // Lista vazia
    anonimo = null;

    // Limpa dados de localização
    latitude = null;
    longitude = null;
    estado = null;
    bairro = null;
    municipio = null;
    logradouro = null;
    endereco = null;
    enderecoConfirmado = false;  // Volta ao padrão
    localizacao = null;
    posicao = null;

    // Limpa dados do usuário (mantém token para próximas denúncias)
    usuarioEmail = null;
    usuarioId = null;
    
    // Reseta estados de confirmação
    categoriaConfirmada = null;
    identificacaoConfirmada = false;  // Volta ao padrão
  }

  // Fim da classe DenunciaData
  // 
  // Singleton para dados de denúncia com:
  // 
  // 🔄 PADRÃO SINGLETON:
  // - Instância única global
  // - Factory constructor
  // - Construtor privado
  // - Persistência entre telas
  // 
  // 📋 DADOS ORGANIZADOS:
  // - Categoria e subcategoria
  // - Dados da ocorrência
  // - Informações do usuário
  // - Localização completa
  // - Estados de confirmação
  // 
  // ⚙️ MÉTODOS UTILITÁRIOS:
  // - toJson(): Serialização para API
  // - limpar(): Reset completo dos dados
  // - Campos nulláveis para flexibilidade
  // - Listas inicializadas vazias
  // 
  // 📱 USO NO FLUXO:
  // - Mantém dados entre telas
  // - Permite navegação para trás/frente
  // - Centraliza estado da denúncia
  // - Facilita envio final para API
}
