import 'package:flutter/foundation.dart';

class ApiConstants {
  // localhost untuk Chrome/Web & iOS Simulator
  // 10.0.2.2 untuk Android Emulator
  // Ganti dengan IP lokal jika menggunakan device fisik (cth: 192.168.1.x)
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    return 'http://10.0.2.2:3000'; // Android emulator
  }

  static const String siswaEndpoint = '/siswa';
}

