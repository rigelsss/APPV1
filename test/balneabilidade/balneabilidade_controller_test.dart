import 'package:flutter_test/flutter_test.dart';
import 'package:sudema_app/screens/balneabilidade/controller/balneabilidade_controller.dart';

void main() {
  late BalneabilidadeController controller;

  setUp(() {
    controller = BalneabilidadeController();
  });

  test('getClassificacaoLabel retorna todas quando tem as duas classificacoes', () {
    controller.classificacoesSelecionadas = ['Próprias', 'Impróprias'];
    expect(controller.getClassificacaoLabel(), ClassificacaoLabels.todas);
  });

  test('getClassificacaoLabel retorna proprias quando só tem Próprias', () {
    controller.classificacoesSelecionadas = ['Próprias'];
    expect(controller.getClassificacaoLabel(), ClassificacaoLabels.proprias);
  });

  test('getClassificacaoLabel retorna improprias quando só tem Impróprias', () {
    controller.classificacoesSelecionadas = ['Impróprias'];
    expect(controller.getClassificacaoLabel(), ClassificacaoLabels.improprias);
  });
  test('resetarFiltros zera filtros de municipio, praia e trecho', () {
    controller.municipioSelecionado = 'Algum lugar';
    controller.praiaSelecionada = 'Praia X';
    controller.trechoSelecionado = 'Trecho Y';

    controller.resetarFiltros();

    expect(controller.municipioSelecionado, '');
    expect(controller.praiaSelecionada, '');
    expect(controller.trechoSelecionado, '');
  });


}
