/// LOCALIZACAO_SERVICE
///
/// Responsável por: Gerenciar permissões e obtenção da localização GPS do usuário
/// para centralizar o mapa e exibir marcador de posição atual.
/// Utilizado em: Controller de balneabilidade para funcionalidades de localização.

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocalizacaoService {
  /// VERIFICARPERMISSOES
  ///
  /// Descrição: Verifica e solicita permissões de localização necessárias.
  /// Retorno: Future<bool> - true se permissões concedidas, false caso contrário
  ///
  /// Fluxo: verifica serviço → verifica permissão → solicita se negada → valida resultado
  static Future<bool> verificarPermissoes() async {
    // Verifica se serviço de localização está habilitado no dispositivo
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false; // GPS desabilitado

    // Verifica permissão atual do app
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Solicita permissão se ainda não foi concedida
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false; // Usuário negou
    }

    // Verifica se permissão foi negada permanentemente
    if (permission == LocationPermission.deniedForever) return false;

    return true; // Permissões OK
  }

  /// OBTERLOCALIZACAOATUAL
  ///
  /// Descrição: Obtém coordenadas GPS atuais do usuário após verificar permissões.
  /// Retorno: Future<LatLng?> - coordenadas ou null se falhar
  ///
  /// Usado para centralizar mapa na posição do usuário e criar marcador.
  static Future<LatLng?> obterLocalizacaoAtual() async {
    // Verifica permissões antes de tentar obter localização
    bool permissoesOk = await verificarPermissoes();
    if (!permissoesOk) return null; // Falha nas permissões

    // Obtém posição atual com precisão padrão
    final position = await Geolocator.getCurrentPosition();
    // Converte para formato do Google Maps
    return LatLng(position.latitude, position.longitude);
  }
}
