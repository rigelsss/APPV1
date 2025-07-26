/// CATEGORIAS_CONTROLLER
///
/// Responsável por: Gerenciar o estado e lógica da etapa de seleção de categorias de denúncias.
/// Utilizado em: Controle da segunda etapa do fluxo de denúncias (seleção de categoria).
/// 
/// Este controller gerencia:
/// - Carregamento de categorias e subcategorias da API
/// - Validação de navegação entre etapas do fluxo
/// - Seleção de categoria e subcategoria
/// - Estado de expansão dos itens da lista
/// - Autenticação do usuário para denúncias identificadas

import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denuncia/categoria/service/categoria_service.dart';

class CategoriasController {
  // Estado da navegação entre abas do fluxo de denúncia
  int selectedIndex = 0;
  
  // Seleções do usuário
  String? categoriaSelecionada;     // Categoria principal selecionada
  String? subcategoriaSelecionada;  // Subcategoria/tipo específico selecionado
  
  // Controle de interface
  final Set<int> categoriasExpandidas = {}; // Índices das categorias expandidas na lista
  List<dynamic> categorias = [];            // Dados das categorias carregadas da API
  bool isLoadingCategorias = true;          // Estado de carregamento das categorias
  String? mensagemErro;                     // Mensagem de erro para validações
  
  // Autenticação
  String? _token; // Token JWT para usuários logados

  // Mapeamento de ícones para cada categoria de infração ambiental
  final Map<int, String> iconesPorCategoria = {
    1: 'assets/images/fauna.png',           // Fauna
    2: 'assets/images/flora.png',           // Flora
    3: 'assets/images/poluicao.png',        // Poluição
    4: 'assets/images/areas_protegidas.png', // Áreas Protegidas
    5: 'assets/images/residuos.png',        // Resíduos
    6: 'assets/images/recursoshidricos.png', // Recursos Hídricos
    7: 'assets/images/outra.png',           // Outras infrações
  };

  /// init
  ///
  /// Descrição: Inicializa o controller, limpando dados anteriores e carregando informações necessárias.
  /// Parâmetros:
  /// - onUpdate: callback para atualizar a interface após carregamento
  /// Retorno: Future<void>
  ///
  /// Prepara o controller para uma nova denúncia.
  Future<void> init(Function() onUpdate) async {
    DenunciaData().limpar(); // Limpa dados de denúncias anteriores
    await carregarToken();   // Carrega token de autenticação
    await carregarCategorias(); // Busca categorias da API
    onUpdate(); // Atualiza a interface
  }

  /// carregarToken
  ///
  /// Descrição: Carrega o token JWT armazenado localmente.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Necessário para identificar usuários em denúncias não anônimas.
  Future<void> carregarToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    if (savedToken != null && savedToken.isNotEmpty) {
      _token = savedToken;
    }
  }

  /// isLoggedIn
  ///
  /// Descrição: Verifica se o usuário está autenticado com token válido.
  /// Parâmetros: nenhum
  /// Retorno: bool - true se logado e token válido
  ///
  /// Usado para determinar se a denúncia será identificada ou anônima.
  bool get isLoggedIn {
    if (_token == null) return false;
    try {
      return !JwtDecoder.isExpired(_token!); // Verifica se token não expirou
    } catch (_) {
      return false; // Token inválido
    }
  }

  /// carregarCategorias
  ///
  /// Descrição: Busca categorias e subcategorias da API SUDEMA.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Carrega dados hierárquicos para seleção do usuário.
  Future<void> carregarCategorias() async {
    try {
      // Busca categorias com tipos da API
      categorias = await CategoriaService.buscarCategoriasComTipos();
      isLoadingCategorias = false;
    } catch (e) {
      // Em caso de erro, para o loading mas mantém lista vazia
      isLoadingCategorias = false;
    }
  }

  /// podeIrParaAba
  ///
  /// Descrição: Valida se o usuário pode navegar para uma aba específica.
  /// Parâmetros:
  /// - index: índice da aba (0-3)
  /// Retorno: bool - true se pode navegar
  ///
  /// Implementa validação sequencial do fluxo de denúncia.
  bool podeIrParaAba(int index) {
    switch (index) {
      case 0: // Identificação - sempre acessível
        return true;
      case 1: // Categoria - requer identificação confirmada
        return DenunciaData().identificacaoConfirmada == true || DenunciaData().categoriaConfirmada == true;
      case 2: // Localização - requer categoria selecionada
        return DenunciaData().categoriaConfirmada == true;
      case 3: // Denúncia - requer endereço confirmado
        return DenunciaData().enderecoConfirmado == true;
      default:
        return false;
    }
  }

  /// definirMensagemErro
  ///
  /// Descrição: Define mensagem de erro baseada na aba que o usuário tentou acessar.
  /// Parâmetros:
  /// - index: índice da aba que falhou na validação
  /// Retorno: void
  ///
  /// Fornece feedback específico sobre o que precisa ser preenchido.
  void definirMensagemErro(int index) {
    switch (index) {
      case 1: // Tentou ir para categoria sem identificação
        mensagemErro = 'Preencha os dados de identificação antes de continuar.';
        break;
      case 2: // Tentou ir para localização sem categoria
        mensagemErro = 'Selecione uma categoria e subcategoria antes de continuar.';
        break;
      case 3: // Tentou ir para denúncia sem endereço
        mensagemErro = 'Confirme o endereço antes de continuar.';
        break;
    }
  }

  /// selecionarCategoria
  ///
  /// Descrição: Seleciona categoria principal e limpa subcategoria anterior.
  /// Parâmetros:
  /// - texto: nome da categoria selecionada
  /// Retorno: void
  void selecionarCategoria(String texto) {
    categoriaSelecionada = texto;
    subcategoriaSelecionada = null; // Limpa subcategoria ao mudar categoria
    mensagemErro = null; // Limpa mensagens de erro
  }

  /// selecionarSubcategoria
  ///
  /// Descrição: Confirma seleção de subcategoria e atualiza dados da denúncia.
  /// Parâmetros:
  /// - nome: nome da subcategoria
  /// - id: ID do tipo de denúncia para a API
  /// - texto: nome da categoria pai
  /// Retorno: void
  ///
  /// Salva dados necessários para envio da denúncia.
  void selecionarSubcategoria(String nome, int id, String texto) {
    subcategoriaSelecionada = nome;
    categoriaSelecionada = texto;
    // Salva dados no modelo global da denúncia
    DenunciaData().tipoDenunciaId = id.toString();
    DenunciaData().usuarioEmail = isLoggedIn ? JwtDecoder.decode(_token!)['email'] : null;
    DenunciaData().categoriaConfirmada = true; // Habilita próxima etapa
    DenunciaData().nomeCategoriaSelecionada = categoriaSelecionada;
    DenunciaData().nomeSubcategoriaSelecionada = subcategoriaSelecionada;
    mensagemErro = null;
  }

  /// alternarExpansaoCategoria
  ///
  /// Descrição: Controla expansão/contração de categorias na lista.
  /// Parâmetros:
  /// - index: índice da categoria na lista
  /// Retorno: void
  ///
  /// Gerencia estado visual da interface expansível.
  void alternarExpansaoCategoria(int index) {
    if (categoriasExpandidas.contains(index)) {
      categoriasExpandidas.remove(index); // Contrai categoria
    } else {
      categoriasExpandidas.add(index); // Expande categoria
    }
  }
}
