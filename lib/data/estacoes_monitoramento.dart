import 'package:google_maps_flutter/google_maps_flutter.dart';


class EstacaoMonitoramento {
  final String nome;
  final String codigo;
  final String endereco;
  final String municipio;
  final LatLng coordenadas;

  EstacaoMonitoramento({
    required this.nome,
    required this.codigo,
    required this.endereco,
    required this.municipio,
    required this.coordenadas,
  });
}


  final List<EstacaoMonitoramento> estacoes = [
    
    //Mataraca
    EstacaoMonitoramento(
      nome: 'Barra do Guajú',
      codigo: '01.01',
      endereco: 'Em frente à desembocadura do Rio Guajú',
      municipio: 'Mataraca',
      coordenadas: LatLng(-6.487729, -34.968220),
    ),

    EstacaoMonitoramento(
      nome: 'Pavuna',
      codigo: '01.00',
      endereco: 'Em frente à Lagoa da Pavuna',
      municipio: 'Mataraca',
      coordenadas: LatLng(-6.543575, -34.966631),
    ),

    EstacaoMonitoramento(
      nome: 'Baleia',
      codigo: '01.01A',
      endereco: 'No final do acesso à praia da Rua Valfredo Medeiros',
      municipio: 'Mataraca',
      coordenadas: LatLng(-6.595602, -34.966260),
    ),

    EstacaoMonitoramento(
      nome: 'Barra do Camaratuba',
      codigo: '01.02',
      endereco: 'Foz do Rio Camaratuba',
      municipio: 'Mataraca',
      coordenadas: LatLng(-6.601995, -34.965790),
    ),

  
    // Baía da Traição
    EstacaoMonitoramento(
      nome: 'Camaratuba',
      codigo: '02.00',
      endereco: 'Em frente a desembocadura do Rio Camaratuba',
      municipio: 'Baia da Traição',
      coordenadas: LatLng(-6.603987, -34.963635),
    ),

    EstacaoMonitoramento(
      nome: 'Tambá',
      codigo: '02.00A',
      endereco: 'Final do acesso à praia na Aldeia Galego',
      municipio: 'Baia da Traição',
      coordenadas: LatLng(-6.663785, -34.956177),
    ),

    EstacaoMonitoramento(
      nome: 'Praia do Forte',
      codigo: '02.01',
      endereco: 'No final da Rua Don Pedro II',
      municipio: 'Baia da Traição',
      coordenadas: LatLng(-6.687934, -34.934072),
    ),

    EstacaoMonitoramento(
      nome: 'Baia da Traição',
      codigo: '02.02',
      endereco: 'No final da Rua Siqueira Campos',
      municipio: 'Baia da Traição',
      coordenadas: LatLng(-6.690453, -34.930905),
    ),

    EstacaoMonitoramento(
      nome: 'Trincheiras',
      codigo: '02.03',
      endereco: 'No final da Rua José Edmilson de Medeiros',
      municipio: 'Baia da Traição',
      coordenadas: LatLng(-6.690261, -34.930703),
    ),

    EstacaoMonitoramento(
      nome: 'Acajutibiró',
      codigo: '02.04',
      endereco: 'No final da Rua Projetada Seis',
      municipio: 'Baia da Traição',
      coordenadas: LatLng(-6.698000, -34.934122),
    ),

    //Rio Tinto
    EstacaoMonitoramento(
      nome: 'Barra do Mamanguape',
      codigo: '03.01',
      endereco: 'Foz do rio Mamanguape',
      municipio: 'Rio Tinto',
      coordenadas: LatLng(-6.773987, -34.915793), 
    ),

    EstacaoMonitoramento(
      nome: 'Praia de Campina',
      codigo: '03.02',
      endereco: 'No final da PB 008',
      municipio: 'Rio Tinto',
      coordenadas: LatLng(-6.812189, -34.913502), 
    ),

    EstacaoMonitoramento(
      nome: 'Praia de Oiteiro',
      codigo: '03.03',
      endereco: 'Trechos próximos a foz do Rio Miriri',
      municipio: 'Rio Tinto',
      coordenadas: LatLng(-6.867742, -34.897127), 
    ),

    // Lucena
    EstacaoMonitoramento(
      nome: 'Bomsucesso',
      codigo: '04.00',
      endereco: 'No final da Rua Mariano de Souza Falcão',
      municipio: 'Lucena',
      coordenadas: LatLng(-6.887270, -34.884147), 
    ),

    EstacaoMonitoramento(
      nome: 'Lucena',
      codigo: '04.01',
      endereco: 'Em frente a desembocadura do Riacho Bonsucesso',
      municipio: 'Lucena',
      coordenadas: LatLng(-6.895764, -34.871049),
    ),

    EstacaoMonitoramento(
      nome: 'Ponta de Lucena',
      codigo: '04.01A',
      endereco: 'Na desembocadura da Camboa em Ponta de Lucena',
      municipio: 'Lucena',
      coordenadas: LatLng(-6.900010, -34.856764),
    ),

    EstacaoMonitoramento(
      nome: 'Gameleira',
      codigo: '04.01B',
      endereco: 'Em frente a desembocadura do Riacho Araçá',
      municipio: 'Lucena',
      coordenadas: LatLng(-6.919102, -34.862689),
    ),

    EstacaoMonitoramento(
      nome: 'Fagundes',
      codigo: '04.01C',
      endereco: 'No final da Travessa São José',
      municipio: 'Lucena',
      coordenadas: LatLng(-6.938403, -34.865541),
    ),

    EstacaoMonitoramento(
      nome: 'Costinha',
      codigo: '04.02',
      endereco: 'No final da Rua Ubiratan Galvão',
      municipio: 'Lucena',
      coordenadas: LatLng(-6.964537, -34.855211),
    ),

    // Cabedelo
    EstacaoMonitoramento(
      nome: 'Miramar',
      codigo: '05.01',
      endereco: 'No final da Av. Cassiano da Cunha Nóbrega',
      municipio: 'Cabedelo',
      coordenadas: LatLng(-6.965204, -34.843184),
    ),

    EstacaoMonitoramento(
      nome: 'Ponta de Mato',
      codigo: '05.02',
      endereco: 'No final da Rua Nossa senhora dos Navegantes',
      municipio: 'Cabedelo',
      coordenadas: LatLng(-6.970960, -34.828280),
    ),

    EstacaoMonitoramento(
      nome: 'Formosa',
      codigo: '05.02A',
      endereco: 'No final da Rua Monsenhor José Coutinho da silva',
      municipio: 'Cabedelo',
      coordenadas: LatLng(-6.984694, -34.827232),
    ),

    EstacaoMonitoramento(
      nome: 'Areia Dourada',
      codigo: '05.02B',
      endereco: 'No final da Rua Projetada',
      municipio: 'Cabedelo',
      coordenadas: LatLng(-6.986448, -34.827126),
    ),

    EstacaoMonitoramento(
      nome: 'Camboinha',
      codigo: '05.03',
      endereco: 'No final da Rua Benício de Oliveira',
      municipio: 'Cabedelo',
      coordenadas: LatLng(-7.014296, -34.828011),
    ),

    EstacaoMonitoramento(
      nome: 'Poço',
      codigo: '05.04',
      endereco: 'No final da Rua Santa Cavalcante',
      municipio: 'Cabedelo',
      coordenadas: LatLng(-7.024640, -34.829534),
    ),

    EstacaoMonitoramento(
      nome: 'Ponta de Campina',
      codigo: '05.04A',
      endereco: 'Em frente a galeria de águas pluviais',
      municipio: 'Cabedelo',
      coordenadas: LatLng(-7.030799, -34.829588),
    ),

    EstacaoMonitoramento(
      nome: 'Intermares',
      codigo: '05.05',
      endereco: 'Em frente ao Maceió de intermares',
      municipio: 'Cabedelo',
      coordenadas: LatLng(-7.046902, -34.840636),
    ),

    // João Pessoa
    EstacaoMonitoramento(
      nome: 'Bessa I',
      codigo: '06.01',
      endereco: 'Em frente a desembocadura do Maceió do Bessa',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.056049, -34.842945),
    ),

    EstacaoMonitoramento(
      nome: 'Bessa',
      codigo: '06.01.1',
      endereco: 'No final da Rua Dr. Abel Beltrão',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.076567, -34.829742),
    ),

    EstacaoMonitoramento(
      nome: 'Bessa II',
      codigo: '06.01A',
      endereco: 'Final da Av. Gov. Flávio Ribeiro Coutinho',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.097050, -34.832673),
    ),

    EstacaoMonitoramento(
      nome: 'Manaira',
      codigo: '06.02B3',
      endereco: 'Em frente ao N° 1461 da Av. João Maurício',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.099747, -34.831722),
    ),

    EstacaoMonitoramento(
      nome: 'Manaira',
      codigo: '06.02B',
      endereco: 'Em frente a quadra de Manaíra',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.105219, -34.828211),
    ),

    EstacaoMonitoramento(
      nome: 'Manaira',
      codigo: '06.02C1',
      endereco: 'Em frente ao N° 315 da Av. João Maurício',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.107848, -34.825702),
    ),

    EstacaoMonitoramento(
      nome: 'Manaira',
      codigo: '06.02C',
      endereco: 'No final da Av. Ruy Carneiro',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.109671, -34.823239),
    ),

    EstacaoMonitoramento(
      nome: 'Tambaú',
      codigo: '06.03A',
      endereco: 'Em frente ao busto de Tamandaré',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.119446, -34.822435),
    ),

    EstacaoMonitoramento(
      nome: 'Cabo Branco',
      codigo: '06.04A',
      endereco: 'No final da Av. Monsenhor Odilon Coutinho',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.124616, -34.822597),
    ),

    EstacaoMonitoramento(
      nome: 'Cabo Branco',
      codigo: '06.04.1A',
      endereco: 'No final da Rua Gregorio Pessoa de Oliveira',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.136117, -34.818450),
    ),

    EstacaoMonitoramento(
      nome: 'Cabo Branco',
      codigo: '06.04B',
      endereco: 'No final da Rua Áurea',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.140778, -34.814863),
    ),

    EstacaoMonitoramento(
      nome: 'Cabo Branco',
      codigo: '06.04C',
      endereco: 'Em frente a rotatória do Cabo Branco',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.145308, -34.808880),
    ),

    EstacaoMonitoramento(
      nome: 'Farol do Cabo Branco',
      codigo: '06.05A',
      endereco: 'Em frente a galeria de águas pluviais',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.148669, -34.795913),
    ),

    EstacaoMonitoramento(
      nome: 'Seixas',
      codigo: '06.05',
      endereco: 'No final da Av. das Falésias',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.153022, -34.793428),
    ),

    EstacaoMonitoramento(
      nome: 'Penha',
      codigo: '06.06',
      endereco: 'Em frente a desembocadura do Rio Cabelo',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.162945, -34.794986),
    ),

    EstacaoMonitoramento(
      nome: 'Penha',
      codigo: '06.06A',
      endereco: 'Em frente a desembocadura do Rio Aratu',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.174709, -34.795712),
    ),

    EstacaoMonitoramento(
      nome: 'Jacarapé',
      codigo: '06.07A',
      endereco: 'Ao final da Rua Manoel Cândido Soares',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.199658, -34.797793),
    ),

    EstacaoMonitoramento(
      nome: 'Arraial',
      codigo: '06.07',
      endereco: 'Em frente a desembocadura do Rio Cuiá',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.210162, -34.802291),
    ),

    EstacaoMonitoramento(
      nome: 'Sol',
      codigo: '06.08',
      endereco: 'Em frente a desembocadura do Riacho Camurupim',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.216874, -34.803998),
    ),

    EstacaoMonitoramento(
      nome: 'Barra do Gramame',
      codigo: '06.09',
      endereco: 'Em frente a desembocadura do Rio Gramame',
      municipio: 'João Pessoa',
      coordenadas: LatLng(-7.242874, -34.804738),
    ),
    
    // Conde
    EstacaoMonitoramento(
      nome: 'Amor',
      codigo: '07.00A',
      endereco: 'Em frente a desembocadura do Rio Gurugi',
      municipio: 'Conde',
      coordenadas: LatLng(-7.273335, -34.802052),
    ),

    EstacaoMonitoramento(
      nome: 'Jacumã',
      codigo: '07.01',
      endereco: 'Em frente a desembocadura do maceió de Jacumã',
      municipio: 'Conde',
      coordenadas: LatLng(-7.291427, -34.801195),
    ),

    EstacaoMonitoramento(
      nome: 'Carapibús',
      codigo: '07.00',
      endereco: 'No final da Rua Maria Carmelita Vasconselos',
      municipio: 'Conde',
      coordenadas: LatLng(-7.297270, -34.801034),
    ),

    EstacaoMonitoramento(
      nome: 'Tabatinga',
      codigo: '07.01A',
      endereco: 'Em frente a desembocadura do Maceió Bucatu',
      municipio: 'Conde',
      coordenadas: LatLng(-7.310675, -34.801824),
    ),

    EstacaoMonitoramento(
      nome: 'Coqueirinho',
      codigo: '07.02',
      endereco: 'Enseada de Coqueirinho',
      municipio: 'Conde',
      coordenadas: LatLng(-7.3230, -34.7967),
    ),

    EstacaoMonitoramento(
      nome: 'Tambaba',
      codigo: '07.03',
      endereco: '',
      municipio: 'Conde',
      coordenadas: LatLng(-7.365489, -34.797505),
    ),

    EstacaoMonitoramento(
      nome: 'Barra do Graú',
      codigo: '07.04',
      endereco: 'Foz do Rio Graú',
      municipio: 'Conde',
      coordenadas: LatLng(-7.385446, -34.802276),
    ),

    // Pitimbú
    EstacaoMonitoramento(
      nome: 'Bela',
      codigo: '08.00A',
      endereco: 'Em frente ao Maceió de Praia Bela',
      municipio: 'Pitimbú',
      coordenadas: LatLng(-7.400166, -34.804431),
    ),

    EstacaoMonitoramento(
      nome: 'Barra do Abiaí',
      codigo: '08.00B',
      endereco: 'Foz do Rio Abiaí',
      municipio: 'Pitimbú',
      coordenadas: LatLng(-7.438724, -34.807746),
    ),

    EstacaoMonitoramento(
      nome: 'Pitimbú',
      codigo: '08.00',
      endereco: 'No final da Rua da Paz',
      municipio: 'Pitimbú',
      coordenadas: LatLng(-7.470920, -34.803992),
    ),

    EstacaoMonitoramento(
      nome: 'Maceió',
      codigo: '08.01',
      endereco: 'Em frente a desembocadura do riacho Engenho Velho',
      municipio: 'Pitimbú',
      coordenadas: LatLng(-7.476475, -34.808615),
    ),

    EstacaoMonitoramento(
      nome: 'Guarita',
      codigo: '08.02',
      endereco: 'Em frente a desembocadura da Lagoa',
      municipio: 'Pitimbú',
      coordenadas: LatLng(-7.480631, -34.811226),
    ),

    EstacaoMonitoramento(
      nome: 'Azul/Santa Rita',
      codigo: '08.03',
      endereco: 'Em frente as galerias de águas pluviais',
      municipio: 'Pitimbú',
      coordenadas: LatLng(-7.483281, -34.812320),
    ),

    EstacaoMonitoramento(
      nome: 'Coqueiros',
      codigo: '08.04',
      endereco: 'No final da Rua Almirante Tamandaré',
      municipio: 'Pitimbú',
      coordenadas: LatLng(-7.533119, -34.821517),
    ),

    EstacaoMonitoramento(
      nome: 'Ponta dos Coqueiros',
      codigo: '08.04A',
      endereco: 'Em frente a desembocadura da Lagoa',
      municipio: 'Pitimbú',
      coordenadas: LatLng(-7.503151, -34.811427),
    ),

    EstacaoMonitoramento(
      nome: 'Acaú/Pontinha',
      codigo: '08.05',
      endereco: 'Em frente a desembocadura do Rio Goiana',
      municipio: 'Pitimbú',
      coordenadas: LatLng(-7.552176, -34.827788),
    ),

  ];
