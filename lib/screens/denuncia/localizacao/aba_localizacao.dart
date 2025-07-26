/// ABA_LOCALIZACAO
///
/// Responsável por: Gerenciar a etapa 3 do fluxo de denúncias - definição de localização.
/// Utilizado em: Terceira aba do processo de criação de denúncias ambientais.
/// 
/// Esta tela integra:
/// - Mapa interativo do Google Maps
/// - Geocodificação reversa para obter endereço
/// - Busca manual de endereços via Google Places API
/// - Validação de dados de endereço obrigatórios
/// - Confirmação de localização para avançar no fluxo
/// - Interface responsiva com painel inferior

import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/denuncia/localizacao/endereco_modal_sheet.dart';
import 'widgets/mapa_interativo.dart';
import 'widgets/painel_confirmar_endereco.dart';

class AbaLocalizacao extends StatefulWidget {
  final VoidCallback onEnderecoConfirmado; // Callback para avançar para próxima etapa
  const AbaLocalizacao({super.key, required this.onEnderecoConfirmado});

  @override
  State<AbaLocalizacao> createState() => _AbaLocalizacaoState();
}

class _AbaLocalizacaoState extends State<AbaLocalizacao> {
  // Estado da localização atual
  LatLng? _posicaoAtual;                                    // Coordenadas GPS selecionadas
  String _endereco = 'Carregando endereço...';              // Endereço formatado da posição
  final TextEditingController _buscaController = TextEditingController(); // Campo de busca
  late GoogleMapController _mapController;                  // Controlador do Google Maps

  // Controle de layout responsivo
  final GlobalKey _painelKey = GlobalKey();                 // Chave para medir altura do painel
  double _alturaPainel = 0;                                 // Altura calculada do painel inferior

  /// atualizarEndereco
  ///
  /// Descrição: Atualiza posição e endereço quando usuário move o mapa ou seleciona local.
  /// Parâmetros:
  /// - novaPosicao: coordenadas GPS da nova posição
  /// - endereco: endereço formatado obtido por geocodificação reversa
  /// Retorno: void
  ///
  /// Sincroniza estado da interface com nova localização selecionada.
  void atualizarEndereco(LatLng novaPosicao, String endereco) {
    setState(() {
      _posicaoAtual = novaPosicao;
      _endereco = endereco;
      _buscaController.text = endereco; // Atualiza campo de busca
    });
  }

  /// confirmarEndereco
  ///
  /// Descrição: Valida e confirma endereço selecionado para avançar no fluxo.
  /// Parâmetros: nenhum
  /// Retorno: void
  ///
  /// Verifica se dados obrigatórios estão preenchidos antes de prosseguir.
  void confirmarEndereco() {
    if (_posicaoAtual == null) return;

    final dados = DenunciaData();
    // Validação: verifica se campos obrigatórios do endereço estão preenchidos
    if ([dados.estado, dados.bairro, dados.municipio, dados.logradouro].any((e) => e == null || e.isEmpty)) {
      // Exibe mensagem de erro se endereço estiver incompleto
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        duration: Duration(seconds: 3),
        backgroundColor: Color(0xFFF8DFDD), // Fundo vermelho claro
        icon: SvgPicture.asset(
          'assets/icon/x-circle.svg',
          width: 28,
          height: 28,
          color: Colors.red,
        ),
        messageText: Text(
          'Endereço incompleto. Tente reposicionar o mapa ou buscar manualmente.',
          style: TextStyle(
            color: Colors.red,
            fontSize: 16,
          ),
        ),
      ).show(context);
      return;
    }

    // Salva coordenadas e endereço no modelo global da denúncia
    dados.latitude = double.parse(_posicaoAtual!.latitude.toStringAsFixed(8));
    dados.longitude = double.parse(_posicaoAtual!.longitude.toStringAsFixed(8));
    dados.endereco = _endereco;
    dados.enderecoConfirmado = true; // Habilita próxima etapa

    // Avança para etapa final de denúncia
    widget.onEnderecoConfirmado();
  }

  /// abrirBuscaManual
  ///
  /// Descrição: Abre modal de busca manual de endereços via Google Places API.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Permite ao usuário buscar endereço por texto quando GPS não é preciso.
  Future<void> abrirBuscaManual() async {
    // Abre modal bottom sheet com busca de endereços
    final resultado = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite controle total da altura
      backgroundColor: Colors.transparent,
      builder: (_) => const EnderecoModalSheet(),
    );

    // Processa resultado da busca se usuário selecionou um endereço
    if (resultado != null && resultado['latLng'] != null) {
      final destino = resultado['latLng'] as LatLng;
      final endereco = resultado['endereco'];

      // Anima mapa para a nova posição selecionada
      _mapController.animateCamera(CameraUpdate.newLatLng(destino));

      // Atualiza estado com nova localização
      atualizarEndereco(destino, endereco);
    }
  }

  /// Widget AbaLocalizacao
  ///
  /// Descrição: Interface principal da etapa de localização com mapa e painel de confirmação.
  /// Combina mapa interativo, pin central e painel inferior responsivo.
  @override
  Widget build(BuildContext context) {
    // Verifica se endereço atual é válido para habilitar botão de confirmação
    final enderecoValido = DenunciaData().endereco != null &&
        DenunciaData().endereco!.isNotEmpty &&
        DenunciaData().endereco != 'Endereço não encontrado';

    // Calcula altura do painel inferior para ajustar layout do mapa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _painelKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null && mounted) {
        setState(() {
          _alturaPainel = renderBox.size.height;
        });
      }
    });

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          // Mapa interativo do Google Maps
          MapaInterativo(
            posicaoAtual: _posicaoAtual,
            onAtualizarPosicao: atualizarEndereco, // Callback para atualizações
            onMapCreatedExternal: (controller) {
              _mapController = controller; // Salva referência do controlador
            },
            paddingBottom: _alturaPainel, // Ajusta padding para o painel
          ),

          // Loading enquanto obtém localização inicial
          if (_posicaoAtual == null)
            const Center(child: CircularProgressIndicator()),

          // Pin vermelho centralizado no mapa
          if (_alturaPainel > 0)
            Positioned(
              // Calcula posição central considerando altura do painel
              top: (MediaQuery.of(context).size.height - _alturaPainel) / 2 - 125,
              left: MediaQuery.of(context).size.width / 2 - 20,
              child: const Icon(
                Icons.location_pin,
                size: 40,
                color: Colors.red,
              ),
            ),

          // Painel inferior com campo de busca e botão de confirmação
          PainelConfirmarEndereco(
            key: _painelKey, // Chave para medir altura
            controller: _buscaController,
            enderecoValido: enderecoValido,
            onPesquisarPress: abrirBuscaManual, // Abre busca manual
            onConfirmarPress: confirmarEndereco, // Confirma e avança
          ),
        ],
      ),
    );
  }
}
