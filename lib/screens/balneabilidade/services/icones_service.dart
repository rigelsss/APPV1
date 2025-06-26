import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IconesService {
  static Future<BitmapDescriptor> carregarIconePropria() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/propria.png',
    );
  }

  static Future<BitmapDescriptor> carregarIconeImpropria() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/impropria.png',
    );
  }

  static Future<BitmapDescriptor> carregarIconeUsuario() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 3.0),
      'assets/images/circle_user_location.png',
    );
  }
}
