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
  final VoidCallback onEnderecoConfirmado;
  const AbaLocalizacao({super.key, required this.onEnderecoConfirmado});

  @override
  State<AbaLocalizacao> createState() => _AbaLocalizacaoState();
}

class _AbaLocalizacaoState extends State<AbaLocalizacao> {
  LatLng? _posicaoAtual;
  String _endereco = 'Carregando endereço...';
  final TextEditingController _buscaController = TextEditingController();
  late GoogleMapController _mapController;

  final GlobalKey _painelKey = GlobalKey();
  double _alturaPainel = 0;

  void atualizarEndereco(LatLng novaPosicao, String endereco) {
    setState(() {
      _posicaoAtual = novaPosicao;
      _endereco = endereco;
      _buscaController.text = endereco;
    });
  }

  void confirmarEndereco() {
    if (_posicaoAtual == null) return;

    final dados = DenunciaData();
    if ([dados.estado, dados.bairro, dados.municipio, dados.logradouro].any((e) => e == null || e.isEmpty)) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        duration: Duration(seconds: 3),
        backgroundColor: Color(0xFFF8DFDD),
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

    dados.latitude = double.parse(_posicaoAtual!.latitude.toStringAsFixed(8));
    dados.longitude = double.parse(_posicaoAtual!.longitude.toStringAsFixed(8));
    dados.endereco = _endereco;
    dados.enderecoConfirmado = true;

    widget.onEnderecoConfirmado();
  }

  Future<void> abrirBuscaManual() async {
    final resultado = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EnderecoModalSheet(),
    );

    if (resultado != null && resultado['latLng'] != null) {
      final destino = resultado['latLng'] as LatLng;
      final endereco = resultado['endereco'];

      _mapController.animateCamera(CameraUpdate.newLatLng(destino));

      atualizarEndereco(destino, endereco);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enderecoValido = DenunciaData().endereco != null &&
        DenunciaData().endereco!.isNotEmpty &&
        DenunciaData().endereco != 'Endereço não encontrado';

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
          MapaInterativo(
            posicaoAtual: _posicaoAtual,
            onAtualizarPosicao: atualizarEndereco,
            onMapCreatedExternal: (controller) {
              _mapController = controller;
            },
            paddingBottom: _alturaPainel, 
          ),

          if (_posicaoAtual == null)
            const Center(child: CircularProgressIndicator()),

          if (_alturaPainel > 0)
            Positioned(
              top: (MediaQuery.of(context).size.height - _alturaPainel) / 2 - 125,
              left: MediaQuery.of(context).size.width / 2 - 20,
              child: const Icon(
                Icons.location_pin,
                size: 40,
                color: Colors.red,
              ),
            ),



          PainelConfirmarEndereco(
            key: _painelKey,
            controller: _buscaController,
            enderecoValido: enderecoValido,
            onPesquisarPress: abrirBuscaManual,
            onConfirmarPress: confirmarEndereco,
          ),
        ],
      ),
    );
  }
}
