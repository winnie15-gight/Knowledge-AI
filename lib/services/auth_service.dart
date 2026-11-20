import '../core/secure_storage.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await ApiService.post('/api/auth/login', {
      'email': email,
      'password': password,
    }, needsAuth: false);
    return res as Map<String, dynamic>;
  }

  static Future<void> verify2fa(String pendingToken, String code) async {
    final res = await ApiService.post('/api/auth/verify-2fa', {
      'pending_token': pendingToken,
      'code': code,
    }, needsAuth: false);

    await SecureStorage.saveAuth(
      accessToken: res['access_token'],
      refreshToken: res['refresh_token'],
      userId: res['user']['id'],
      username: res['user']['username'],
      email: res['user']['email'],
    );
  }

  static Future<void> resend2fa(String pendingToken) async {
    await ApiService.post('/api/auth/resend-2fa', {
      'pending_token': pendingToken,
    }, needsAuth: false);
  }

  static Future<void> signup(String username, String email, String password) async {
    final res = await ApiService.post('/api/auth/signup', {
      'username': username,
      'email': email,
      'password': password,
    }, needsAuth: false);

    await SecureStorage.saveAuth(
      accessToken: res['access_token'],
      refreshToken: res['refresh_token'],
      userId: res['user']['id'],
      username: res['user']['username'],
      email: res['user']['email'],
    );
  }

  static Future<void> logout() async {
    try {
      await ApiService.post('/api/auth/logout', {});
    } catch (_) {}
    await SecureStorage.clearAuth();
  }
}
