/// ENDERECO_MODAL_SHEET
///
/// Responsável por: Modal de busca manual de endereços via Google Places API.
/// Utilizado em: Busca alternativa quando GPS não é preciso ou usuário quer endereço específico.
/// 
/// Este modal oferece:
/// - Campo de busca com autocomplete
/// - Integração com Google Places API
/// - Debounce para otimizar requisições
/// - Lista de sugestões com detalhes
/// - Retorno de coordenadas e endereço formatado
/// - Filtro para resultados apenas do Brasil

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Chave da API do Google Places para busca de endereços
// TODO: Mover para variáveis de ambiente por segurança
const kGoogleApiKey = "AIzaSyD-XTfAdL3WxwtBeKfvPhiu1m3niVn1CaM";

class EnderecoModalSheet extends StatefulWidget {
  const EnderecoModalSheet({super.key});

  @override
  State<EnderecoModalSheet> createState() => _EnderecoModalSheetState();
}

class _EnderecoModalSheetState extends State<EnderecoModalSheet> {
  // Controles da interface
  final TextEditingController _controller = TextEditingController(); // Campo de busca
  late GooglePlace _googlePlace;                                     // Cliente da Google Places API
  List<AutocompletePrediction> _predictions = [];                    // Lista de sugestões
  Timer? _debounce;                                                  // Timer para debounce
  bool _carregando = false;                                          // Estado de carregamento

  @override
  void initState() {
    super.initState();
    // Inicializa cliente da Google Places API
    _googlePlace = GooglePlace(kGoogleApiKey);
  }

  /// _buscarComDebounce
  ///
  /// Descrição: Implementa debounce para evitar muitas requisições durante digitação.
  /// Parâmetros:
  /// - value: texto digitado pelo usuário
  /// Retorno: void
  ///
  /// Aguarda 500ms após última digitação antes de buscar.
  void _buscarComDebounce(String value) {
    // Cancela timer anterior se ainda estiver ativo
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Cria novo timer para buscar após delay
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _buscar(value);
    });
  }

  /// _buscar
  ///
  /// Descrição: Executa busca na Google Places API com filtros para o Brasil.
  /// Parâmetros:
  /// - input: termo de busca digitado
  /// Retorno: void
  ///
  /// Busca endereços com autocomplete limitado ao Brasil em português.
  void _buscar(String input) async {
    // Limpa resultados se campo estiver vazio
    if (input.isEmpty) {
      setState(() => _predictions = []);
      return;
    }

    setState(() => _carregando = true);

    // Busca na Google Places API com filtros
    final result = await _googlePlace.autocomplete.get(
      input,
      language: 'pt',                              // Resultados em português
      components: [Component('country', 'br')],    // Apenas resultados do Brasil
    );

    // Atualiza lista de sugestões
    if (result != null && result.predictions != null) {
      setState(() => _predictions = result.predictions!);
    } else {
      debugPrint("Erro ou sem resultados na busca de endereços");
    }

    setState(() => _carregando = false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final altura = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: altura,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pesquisar",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            onChanged: _buscarComDebounce,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Digite um endereço...",
              suffixIcon: _carregando
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.search, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _predictions.isEmpty && !_carregando
                ? const Center(child: Text("Nenhum resultado"))
                : ListView.builder(
                    itemCount: _predictions.length,
                    itemBuilder: (context, index) {
                      final p = _predictions[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        title: Text(p.structuredFormatting?.mainText ?? ''),
                        subtitle: Text(p.structuredFormatting?.secondaryText ?? ''),
                        onTap: () async {
                          final placeId = p.placeId;
                          if (placeId == null) return;

                          final details = await _googlePlace.details.get(placeId);

                          if (details == null ||
                              details.result == null ||
                              details.result!.geometry == null ||
                              details.result!.geometry!.location == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Erro ao obter detalhes do local.')),
                            );
                            return;
                          }

                          final loc = details.result!.geometry!.location!;
                          final enderecoCompleto = p.description ?? "Endereço não disponível";

                          FocusScope.of(context).unfocus();

                          Navigator.pop(context, {
                            'latLng': LatLng(loc.lat!, loc.lng!),
                            'endereco': enderecoCompleto,
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
