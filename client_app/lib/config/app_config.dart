// import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Web chạy cùng máy host
      return 'http://localhost:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Android emulator => host
        return 'http://10.0.2.2:3000';
      case TargetPlatform.iOS:
        // iOS Simulator
        return 'http://localhost:3000';
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        // Flutter desktop
        return 'http://localhost:3000';
      default:
        // Thiết bị thật: tự điền IP LAN của máy chạy server
        return 'http://192.168.1.23:3000'; // đổi theo mạng của bạn
    }
  }
}
