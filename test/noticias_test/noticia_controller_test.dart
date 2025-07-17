import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sudema_app/screens/noticias/pagina_noticiaCompleta/controller/noticiaCompleta_controller.dart';

class MockClient extends Mock implements http.Client {}
class UriFake extends Fake implements Uri {}

void main() {
  late MockClient mockClient;
  late NoticiaController controller;

  setUpAll(() async {
    registerFallbackValue(UriFake());

    dotenv.testLoad(fileInput: 'URL_API=https://api.exemplo.com');
  });

  setUp(() {
    mockClient = MockClient();
    controller = NoticiaController(client: mockClient);
  });


  test('Retorna erro com status 404', () async {
    when(() => mockClient.get(any())).thenAnswer((_) async {
      return http.Response('Não encontrado', 404);
    });

    await controller.carregarNoticia(999);
    expect(controller.noticia, isNull);
    expect(controller.carregando, isFalse);
    expect(controller.erro, contains('404'));
  });



  test('Lança exceção ao falhar', () async {
    when(() => mockClient.get(any())).thenThrow(Exception('Falha geral'));

    await controller.carregarNoticia(1);
    expect(controller.noticia, isNull);
    expect(controller.carregando, isFalse);
    expect(controller.erro, contains('💥'));
  });
}
