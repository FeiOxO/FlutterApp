import '../models/user.dart';
import '../models/api_response.dart';
import 'api_client.dart';

String? _readString(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  return v.toString();
}

class AuthService {
  final ApiClient _client = ApiClient();

  Future<({String token, String refreshToken, User user})> login({
    required String username,
    required String password,
  }) async {
    final response = await _client.dio.post('/api/auth/login', data: {
      'username': username,
      'password': password,
    });
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) => d as Map<String, dynamic>,
    );
    if (!apiResp.success || apiResp.data == null) {
      throw AuthException(
        message: apiResp.message,
        errors: apiResp.errors,
      );
    }
    final data = apiResp.data!;
    final token = _readString(
      data['token'] ?? data['accessToken'] ?? data['access_token'],
    );
    final refreshToken = _readString(
      data['refreshToken'] ?? data['refresh_token'],
    );
    final userRaw = data['user'];
    Map<String, dynamic>? userMap;
    if (userRaw is Map) {
      userMap = Map<String, dynamic>.from(userRaw);
    } else if (data['id'] != null && data['username'] != null) {
      userMap = Map<String, dynamic>.from(data)
        ..remove('token')
        ..remove('accessToken')
        ..remove('access_token')
        ..remove('refreshToken')
        ..remove('refresh_token');
    }
    if (token == null || userMap == null) {
      throw AuthException(message: '登录响应格式不正确');
    }
    final user = User.fromJson(userMap);
    return (
      token: token,
      refreshToken: refreshToken ?? '',
      user: user,
    );
  }

  Future<User> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _client.dio.post('/api/auth/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) => User.fromJson(d),
    );
    if (!apiResp.success) {
      throw AuthException(
        message: apiResp.message,
        errors: apiResp.errors,
      );
    }
    return apiResp.data!;
  }

  Future<User> getProfile() async {
    final response = await _client.dio.get('/api/auth/me');
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) => User.fromJson(d),
    );
    if (!apiResp.success) throw AuthException(message: apiResp.message);
    return apiResp.data!;
  }

  Future<void> logout() async {
    try {
      await _client.dio.post('/api/auth/logout');
    } catch (_) {}
    await _client.clearTokens();
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await _client.dio.post('/api/auth/refresh', data: {
      'refreshToken': refreshToken,
    });
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) {
        final m = d is Map ? Map<String, dynamic>.from(d) : null;
        final t = _readString(m?['token'] ?? m?['accessToken']);
        if (t == null) {
          throw AuthException(message: '刷新响应格式不正确');
        }
        return t;
      },
    );
    if (!apiResp.success) throw AuthException(message: apiResp.message);
    return apiResp.data!;
  }

  Future<void> forgotPassword(String email) async {
    final response = await _client.dio.post('/api/auth/forgot-password', data: {
      'email': email,
    });
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      null,
    );
    if (!apiResp.success) throw AuthException(message: apiResp.message);
  }
}

class AuthException implements Exception {
  final String message;
  final List<FieldError>? errors;

  AuthException({required this.message, this.errors});

  @override
  String toString() => message;
}
