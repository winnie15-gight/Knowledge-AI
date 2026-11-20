import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUserId = 'user_id';
  static const _keyUsername = 'username';
  static const _keyEmail = 'email';

  static Future<void> saveAuth({
    required String accessToken,
    required String refreshToken,
    required int userId,
    required String username,
    required String email,
  }) async {
    await _storage.write(key: _keyAccessToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
    await _storage.write(key: _keyUserId, value: userId.toString());
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyEmail, value: email);
  }

  static Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);
  static Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);
  static Future<String?> getUsername() => _storage.read(key: _keyUsername);
  static Future<String?> getEmail() => _storage.read(key: _keyEmail);

  static Future<void> clearAuth() async {
    await _storage.deleteAll();
  }
}
