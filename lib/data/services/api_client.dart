import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String _baseUrlKey = 'api_base_url';
  static const String _defaultBaseUrl = 'http://8.138.22.37:3000';
  // static const String _defaultBaseUrl = 'https://feioxo.site';

  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: 'token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        final baseUrl = await _secureStorage.read(key: _baseUrlKey);
        options.baseUrl = baseUrl ?? _defaultBaseUrl;
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Token expired — could add refresh logic here
        }
        handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  Future<void> setBaseUrl(String url) async {
    await _secureStorage.write(key: _baseUrlKey, value: url);
  }

  Future<String> getBaseUrl() async {
    return await _secureStorage.read(key: _baseUrlKey) ?? _defaultBaseUrl;
  }

  Future<void> setToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: 'refreshToken', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refreshToken');
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: 'token');
    await _secureStorage.delete(key: 'refreshToken');
  }
}
