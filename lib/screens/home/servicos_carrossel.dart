/// SERVICOS_CARROSSEL
///
/// Responsável por: Carrossel horizontal de serviços da SUDEMA com navegação interna
/// (balneabilidade, denúncias) e externa (transparência, licenciamento, CTE).
/// Utilizado em: Home para apresentar principais serviços oferecidos pela SUDEMA.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget ServicosCarrossel
///
/// Descrição: ListView horizontal com 5 serviços, indicadores de navegação
/// e tratamento diferenciado para links internos e externos.
class ServicosCarrossel extends StatefulWidget {
  final Function(String label) onSelecionar;  // Callback para serviços internos

  const ServicosCarrossel({super.key, required this.onSelecionar});

  @override
  State<ServicosCarrossel> createState() => _ServicosCarrosselState();
}

class _ServicosCarrosselState extends State<ServicosCarrossel> {
  final ScrollController _scrollController = ScrollController();  // Controla scroll horizontal
  int _indiceAtual = 0;  // Índice atual para indicadores (0 ou 1)

  // Lista de serviços da SUDEMA com configurações de navegação
  final List<Map<String, dynamic>> servicos = [
    // Serviços internos (navegam dentro do app)
    {
      'label': 'Balneabilidade', 
      'key' : 'balneabilidade',
      'image': 'assets/images/balneabilidade.png'
    },
    {
      'label': 'Denúncias', 
      'key' : 'denuncias',
      'image': 'assets/images/denuncia.jpg'
    },
    // Serviços externos (abrem URLs no navegador)
    {
      'label': 'Transparência',
      'key' : 'transparencia',
      'image': 'assets/images/portaltransparencia.jpg',
      'url': 'https://sigma.pb.gov.br/transparencia/'  // Portal de transparência PB
    },
    {
      'label': 'Licenciamento',
      'key' : 'licenciamento',
      'image': 'assets/images/licenciamento.jpg',
      'url': 'https://sigma.pb.gov.br/index/'  // Sistema SIGMA
    },
    {
      'label': 'CTE',
      'key' : 'cte',
      'image': 'assets/images/CTE.jpg',
      'url': 'https://cte.sigma.pb.gov.br/'  // Cadastro Técnico Estadual
    },
  ];

  @override
  void initState() {
    super.initState();
    // Adiciona listener para atualizar indicadores durante scroll
    _scrollController.addListener(_atualizarIndice);
  }

  /// _ATUALIZARINDICE
  ///
  /// Descrição: Atualiza indicador visual baseado na posição do scroll.
  /// Lógica: 0 para início, 1 para final (simplificada para 2 indicadores)
  void _atualizarIndice() {
    final posicao = _scrollController.offset;
    setState(() {
      // Muda indicador após scroll de ~240px (2 itens de 120px)
      _indiceAtual = posicao < 120 * 2 ? 0 : 1; 
    });
  }

  /// _ABRIRURL
  ///
  /// Descrição: Abre URL externa no navegador do dispositivo.
  /// Parâmetros:
  /// - url: URL a ser aberta
  /// Retorno: Future<void>
  Future<void> _abrirUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      // Abre no navegador externo
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir $url';
    }
  }

  @override
  void dispose() {
    // Remove listener e libera recursos
    _scrollController.removeListener(_atualizarIndice);
    _scrollController.dispose();
    super.dispose();
  }

  /// BUILD
  ///
  /// Descrição: Constrói carrossel horizontal de serviços com indicadores de navegação.
  /// Parâmetros:
  /// - context: Contexto do widget para MediaQuery
  /// Retorno: Widget Column com ListView e indicadores
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;  // Breakpoint para tablet

    // Dimensões responsivas dos itens
    final itemHeight = isTablet ? 200.0 : 130.0;   // Altura total do item
    final imageHeight = isTablet ? 140.0 : 80.0;   // Altura da imagem
    final itemWidth = isTablet ? 200.0 : 120.0;    // Largura do item

    return Column(
      children: [
        // Carrossel principal
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: itemHeight,
                child: ListView.builder(
                  controller: _scrollController,      // Para controlar indicadores
                  scrollDirection: Axis.horizontal,   // Scroll horizontal
                  itemCount: servicos.length,         // 5 serviços
                  itemBuilder: (context, index) {
                    final servico = servicos[index];
                    return GestureDetector(
                      // Lógica de navegação baseada no tipo de serviço
                      onTap: () {
                        if (servico.containsKey('url')) {
                          // Serviço externo: abre URL no navegador
                          _abrirUrl(servico['url']);
                        } else {
                          // Serviço interno: executa callback
                          widget.onSelecionar(servico['key'] ?? servico['label']);
                        }
                      },
                      // Card do serviço
                      child: Container(
                        width: itemWidth,                     // Largura responsiva
                        margin: const EdgeInsets.only(right: 12),  // Espaço entre itens
                        decoration: BoxDecoration(
                          color: Colors.grey[200],           // Fundo cinza claro
                          borderRadius: BorderRadius.circular(12),  // Bordas arredondadas
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Imagem do serviço
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.asset(
                                servico['image'],
                                fit: BoxFit.cover,            // Preenche mantendo proporção
                                height: imageHeight,          // Altura responsiva
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Label do serviço
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                servico['label'],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  fontSize: isTablet ? 16 : 14,  // Fonte responsiva
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Indicadores de navegação (simplificados para 2 estados)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIndicador(ativo: _indiceAtual == 0),  // Início do carrossel
            const SizedBox(width: 8),
            _buildIndicador(ativo: _indiceAtual == 1),  // Final do carrossel
          ],
        ),
      ],
    );
  }

  /// _BUILDINDICADOR
  ///
  /// Descrição: Constrói indicador visual animado para posição do carrossel.
  /// Parâmetros:
  /// - ativo: Se este indicador representa a posição atual
  /// Retorno: Widget AnimatedContainer com indicador
  Widget _buildIndicador({required bool ativo}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),  // Animação suave
      width: 30,   // Largura maior que indicadores circulares
      height: 6,   // Altura retangular
      decoration: BoxDecoration(
        // Azul SUDEMA se ativo, cinza se inativo
        color: ativo ? const Color(0xFF2A2F8C) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),  // Bordas arredondadas
      ),
    );
  }

  // Fim da classe ServicosCarrossel
  // 
  // Carrossel de serviços da SUDEMA com:
  // - 5 serviços (2 internos + 3 externos)
  // - Navegação diferenciada por tipo
  // - Layout responsivo mobile/tablet
  // - Indicadores animados de posição
  // - Abertura de URLs externas
  // - Integração com callback para serviços internos
}
