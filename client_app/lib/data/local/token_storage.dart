// lib/data/local/token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _kKey = 'auth_token';
  static const _storage = FlutterSecureStorage();

  static Future<void> save(String token) => _storage.write(key: _kKey, value: token);
  static Future<String?> read() => _storage.read(key: _kKey);
  static Future<void> clear() => _storage.delete(key: _kKey);
}
