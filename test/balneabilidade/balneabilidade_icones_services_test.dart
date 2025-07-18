import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sudema_app/screens/balneabilidade/services/icones_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IconesService', () {
    test('carregarIconePropria retorna BitmapDescriptor', () async {
      final icon = await IconesService.carregarIconePropria();
      expect(icon, isA<BitmapDescriptor>());
    });

    test('carregarIconeImpropria retorna BitmapDescriptor', () async {
      final icon = await IconesService.carregarIconeImpropria();
      expect(icon, isA<BitmapDescriptor>());
    });

    test('carregarIconeUsuario retorna BitmapDescriptor', () async {
      final icon = await IconesService.carregarIconeUsuario();
      expect(icon, isA<BitmapDescriptor>());
    });
  });
}
