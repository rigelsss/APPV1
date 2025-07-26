/// DENUNCIA_RESUMO
///
/// Responsável por: Tela de revisão final antes do envio da denúncia para a API.
/// Utilizado em: Última etapa do fluxo de denúncias, após preenchimento completo.
/// 
/// Esta tela apresenta:
/// - Resumo completo de todas as informações coletadas
/// - Dados de identificação, categoria, localização e denúncia
/// - Preview das imagens anexadas
/// - Botão final para envio à API da SUDEMA
/// - Tratamento de erros e estados de carregamento
/// - Navegação para tela de confirmação após sucesso

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
  // Estado de carregamento durante envio
  bool _enviando = false;
  // Instância do modelo global com todos os dados coletados
  final dados = DenunciaData();

  /// _enviar
  ///
  /// Descrição: Executa o envio final da denúncia para a API da SUDEMA.
  /// Parâmetros: nenhum
  /// Retorno: Future<void>
  ///
  /// Gerencia todo o processo de envio, tratamento de erros e navegação.
  Future<void> _enviar() async {
    setState(() => _enviando = true);
    try {
      // Chama o service para enviar denúncia via API
      final resultado = await DenunciaService.enviar(context, dados);

      if (resultado) {
        // Limpa dados após envio bem-sucedido
        dados.limpar();
        if (!mounted) return;
        // Navega para tela de confirmação
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DenunciaConcluida()),
        );
      }
    } catch (e) {
      // Exibe erro se envio falhar
      _mostrarErro('Erro ao enviar denúncia: ${e.toString()}');
    } finally {
      // Para o loading independente do resultado
      if (mounted) setState(() => _enviando = false);
    }
  }

  /// _mostrarErro
  ///
  /// Descrição: Exibe mensagem de erro via SnackBar.
  /// Parâmetros:
  /// - mensagem: texto do erro a ser exibido
  /// Retorno: void
  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Widget ResumoDenunciaScreen
  ///
  /// Descrição: Interface de revisão final com todos os dados coletados.
  /// Permite confirmação antes do envio definitivo.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DenunciaAppBar(),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Menu superior mostrando todas as etapas (sem seleção ativa)
          const DenunciaMenuSuperior(etapaAtual: -1),

          const SizedBox(height: 16),
          // Título da tela de revisão
          Text(
            'Confira as informações',
            style: GoogleFonts.lato(fontSize: 24),
            textAlign: TextAlign.left,
          ),

          const SizedBox(height: 24),
          // Layout responsivo para o conteúdo
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isTablet = constraints.maxWidth >= 600;

              final Widget conteudo = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seção 1: Identificação
                  Text('Identificação', style: GoogleFonts.lato(fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildCard([
                    if (dados.anonimo == true)
                      _infoValorNegrito('Denúncia Anônima')
                    else
                      _infoValorNegrito(dados.usuarioEmail ?? 'Não informado'),
                  ]),

                  const SizedBox(height: 24),
                  // Seção 2: Categoria da infração
                  Text('Categoria', style: GoogleFonts.lato(fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildCard([
                    _infoValorNormal(dados.nomeCategoriaSelecionada ?? 'Não informada'),
                    _infoValorNegrito(dados.nomeSubcategoriaSelecionada ?? 'Não informada'),
                  ]),

                  const SizedBox(height: 24),
                  // Seção 3: Localização da ocorrência
                  Text('Localização', style: GoogleFonts.lato(fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildCard([
                    _infoValorNormal(dados.municipio ?? 'Não informado'),
                    _infoValorNegrito(dados.logradouro ?? 'Não informado'),
                  ]),

                  const SizedBox(height: 24),
                  // Seção 4: Detalhes da denúncia
                  Text('Denúncia', style: GoogleFonts.lato(fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildCard([
                    _infoRowEspacado('Data', dados.dataOcorrencia ?? 'Não informada'),
                    _infoRowEspacado('Descrição', dados.descricao ?? 'Não informada'),
                    _infoRowEspacado('Ponto de referência', dados.referencia ?? 'Não informado'),
                    _infoRowEspacado('Inf. do denunciado', dados.informacaoDenunciado ?? 'Não informado'),
                    // Lista nomes dos arquivos se houver imagens
                    if (dados.imagemPaths.isNotEmpty)
                      _infoRowEspacado(
                        'Anexos',
                        dados.imagemPaths.map((e) => e.split('/').last).join('     '),
                      ),
                  ]),

                  const SizedBox(height: 16),
                  // Preview das imagens anexadas (se houver)
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
                          // Miniatura de cada imagem anexada
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
                  // Pergunta de confirmação
                  Center(
                    child: Text(
                      'Todas as informações estão corretas?',
                      style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Botão principal de envio
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _enviando ? null : _enviar, // Desabilita durante envio
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B8C00), // Verde SUDEMA
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _enviando
                          ? const CircularProgressIndicator(color: Colors.white) // Loading
                          : Text('Concluir denúncia', style: GoogleFonts.lato(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Botão secundário para voltar
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context), // Volta para etapa anterior
                      child: Text('Voltar', style: GoogleFonts.lato(fontSize: 14, color: const Color(0xFF747474))),
                    ),
                  ),
                ],
              );

              // Layout responsivo: centraliza e limita largura em tablets
              return isTablet
                  ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: conteudo,
                ),
              )
                  : conteudo; // Layout normal para celulares
            },
          ),
        ],
      ),
    );
  }

  /// _buildCard
  ///
  /// Descrição: Cria container estilizado para agrupar informações relacionadas.
  /// Parâmetros:
  /// - children: lista de widgets a serem exibidos no card
  /// Retorno: Widget - container com fundo cinza e bordas arredondadas
  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Fundo cinza claro
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  /// _infoValorNormal
  ///
  /// Descrição: Cria texto com formatação normal para informações secundárias.
  /// Parâmetros:
  /// - texto: conteúdo a ser exibido
  /// Retorno: Widget - texto formatado com peso normal
  Widget _infoValorNormal(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: GoogleFonts.lato(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.normal, // Peso normal para informações secundárias
        ),
      ),
    );
  }

  /// _infoValorNegrito
  ///
  /// Descrição: Cria texto com formatação em negrito para informações principais.
  /// Parâmetros:
  /// - texto: conteúdo a ser exibido
  /// Retorno: Widget - texto formatado em negrito
  Widget _infoValorNegrito(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: GoogleFonts.lato(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold, // Negrito para destaque
        ),
      ),
    );
  }

  /// _infoRowEspacado
  ///
  /// Descrição: Cria linha com label e valor alinhados em colunas.
  /// Parâmetros:
  /// - label: rótulo da informação
  /// - value: valor correspondente
  /// Retorno: Widget - row com label normal e valor em negrito
  Widget _infoRowEspacado(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coluna fixa para labels
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.normal, // Label em peso normal
                color: Colors.black,
              ),
            ),
          ),
          // Coluna expansível para valores
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold, // Valor em negrito
              ),
            ),
          ),
        ],
      ),
    );
  }
}
