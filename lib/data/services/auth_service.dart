import '../models/user.dart';
import '../models/api_response.dart';
import 'api_client.dart';

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
    final token = data['token'] as String;
    final refreshToken = data['refreshToken'] as String;
    final user = User.fromJson(data['user'] as Map<String, dynamic>);
    return (token: token, refreshToken: refreshToken, user: user);
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
      (d) => User.fromJson(d as Map<String, dynamic>),
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
      (d) => User.fromJson(d as Map<String, dynamic>),
    );
    if (!apiResp.success) throw AuthException(message: apiResp.message);
    return apiResp.data!;
  }

  Future<User> setAvatar(String? imageId) async {
    final response = await _client.dio.put('/api/auth/avatar', data: {
      'imageId': imageId,
    });
    final apiResp = ApiResponse.fromJson(
      response.data as Map<String, dynamic>,
      (d) => User.fromJson(d as Map<String, dynamic>),
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
      (d) => (d as Map<String, dynamic>)['token'] as String,
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
