/// FILTROS_CONSTANTS
///
/// Responsável por: Constantes para sistema de filtros da balneabilidade.
/// Utilizado em: Filtros de município, trechos e classificações das praias.
/// 
/// Define:
/// - Labels padrão para opções de filtro
/// - Lista de municípios costeiros da Paraíba
/// - Valores constantes para comparações no sistema

/// Labels para opções de filtro
class FiltrosLabels {
  static const todos = 'Todos';           // Opção para mostrar todos os itens
  static const trechos = 'Trechos';       // Label para dropdown de trechos
  static const municipios = 'Municípios'; // Label para dropdown de municípios
}

/// Lista de municípios costeiros da Paraíba com estações de monitoramento
class ListaMunicipios {
  static const todos = 'Todos';           // Opção para exibir todos os municípios
  
  // Municípios ordenados do norte ao sul do litoral paraibano
  static const nomes = [
    'Todos',
    'Mataraca',        // Extremo norte
    'Baia da Traição', // Norte
    'Rio Tinto',       // Norte
    'Lucena',          // Norte-centro
    'Cabedelo',        // Grande João Pessoa
    'João Pessoa',     // Capital
    'Conde',           // Sul
    'Pitimbú',         // Extremo sul
  ];
}
