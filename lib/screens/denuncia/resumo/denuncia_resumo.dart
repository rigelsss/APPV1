import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudema_app/models/denuncia_data.dart';
import 'package:sudema_app/screens/widgets/appbar_denuncia.dart';
import 'package:sudema_app/screens/denuncia/service/denuncia_service.dart';
import 'package:sudema_app/screens/denuncia/DenunciaConcluida.dart';
import 'package:sudema_app/screens/denuncia/resumo/denuncia_menu_superior.dart';

class ResumoDenunciaScreen extends StatefulWidget {
  const ResumoDenunciaScreen({super.key});

  @override
  State<ResumoDenunciaScreen> createState() => _ResumoDenunciaScreenState();
}

class _ResumoDenunciaScreenState extends State<ResumoDenunciaScreen> {
  bool _enviando = false;
  final dados = DenunciaData();

  Future<void> _enviar() async {
    setState(() => _enviando = true);
    try {
      final resultado = await DenunciaService.enviar(context, dados);

      if (resultado) {
        dados.limpar();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DenunciaConcluida()),
        );
      } /*else {
        _mostrarErro('❌ Erro inesperado: o envio falhou, mas sem detalhes do servidor.');
      }*/
    } catch (e) {
      _mostrarErro('Erro ao enviar denúncia: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DenunciaAppBar(),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const DenunciaMenuSuperior(etapaAtual: -1),

          const SizedBox(height: 16),
          Text(
            'Confira as informações',
            style: GoogleFonts.lato(fontSize: 24),
            textAlign: TextAlign.left,
          ),

          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isTablet = constraints.maxWidth >= 600;

              final Widget conteudo = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Identificação', style: GoogleFonts.lato(fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildCard([
                    if (dados.anonimo == true)
                      _infoValorNegrito('Denúncia Anônima')
                    else
                      _infoValorNegrito(dados.usuarioEmail ?? 'Não informado'),
                  ]),

                  const SizedBox(height: 24),
                  Text('Categoria', style: GoogleFonts.lato(fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildCard([
                    _infoValorNormal(dados.nomeCategoriaSelecionada ?? 'Não informada'),
                    _infoValorNegrito(dados.nomeSubcategoriaSelecionada ?? 'Não informada'),
                  ]),

                  const SizedBox(height: 24),
                  Text('Localização', style: GoogleFonts.lato(fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildCard([
                    _infoValorNormal(dados.municipio ?? 'Não informado'),
                    _infoValorNegrito(dados.logradouro ?? 'Não informado'),
                  ]),

                  const SizedBox(height: 24),
                  Text('Denúncia', style: GoogleFonts.lato(fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildCard([
                    _infoRowEspacado('Data', dados.dataOcorrencia ?? 'Não informada'),
                    _infoRowEspacado('Descrição', dados.descricao ?? 'Não informada'),
                    _infoRowEspacado('Ponto de referência', dados.referencia ?? 'Não informado'),
                    _infoRowEspacado('Inf. do denunciado', dados.informacaoDenunciado ?? 'Não informado'),
                    if (dados.imagemPaths.isNotEmpty)
                      _infoRowEspacado(
                        'Anexos',
                        dados.imagemPaths.map((e) => e.split('/').last).join('     '),
                      ),
                  ]),

                  const SizedBox(height: 16),
                  if (dados.imagemPaths.isNotEmpty) ...[
                    Text('Anexos', style: GoogleFonts.lato(fontSize: 14)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dados.imagemPaths.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return Image.file(
                            File(dados.imagemPaths[index]),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Todas as informações estão corretas?',
                      style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _enviando ? null : _enviar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B8C00),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _enviando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text('Concluir denúncia', style: GoogleFonts.lato(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Voltar', style: GoogleFonts.lato(fontSize: 14, color: const Color(0xFF747474))),
                    ),
                  ),
                ],
              );

              return isTablet
                  ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: conteudo,
                ),
              )
                  : conteudo;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _infoValorNormal(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: GoogleFonts.lato(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget _infoValorNegrito(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: GoogleFonts.lato(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoRowEspacado(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
