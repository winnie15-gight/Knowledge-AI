import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/app_config.dart';
import '../core/error_handler.dart';
import '../core/secure_storage.dart';

class ApiService {
  static Future<Map<String, String>> _headers({bool needsAuth = true}) async {
    final map = {'Content-Type': 'application/json'};
    if (needsAuth) {
      final token = await SecureStorage.getAccessToken();
      if (token != null) {
        map['Authorization'] = 'Bearer $token';
      }
    }
    return map;
  }

  static Future<dynamic> get(String path) async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}$path');
      final res = await http.get(uri, headers: await _headers()).timeout(const Duration(seconds: 25));
      return _process(res);
    } catch (e) {
      throw AppException(ErrorHandler.parse(e));
    }
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body, {bool needsAuth = true}) async {
    try {
      final uri = Uri.parse('${AppConfig.baseUrl}$path');
      final res = await http
          .post(uri, headers: await _headers(needsAuth: needsAuth), body: jsonEncode(body))
          .timeout(const Duration(seconds: 60));
      return _process(res);
    } catch (e) {
      throw AppException(ErrorHandler.parse(e));
    }
  }

  static dynamic _process(http.Response res) {
    dynamic json;
    try {
      json = jsonDecode(res.body);
    } catch (_) {
      json = null;
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json;
    }

    final errorMsg = json is Map && json.containsKey('error')
        ? json['error']
        : 'Request failed (HTTP ${res.statusCode})';
    throw AppException(errorMsg);
  }
}
