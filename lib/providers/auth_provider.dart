import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import 'api_client.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiClient _apiClient = ApiClient();

  User? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get error => _error;

  AuthProvider() {
    _checkSavedSession();
  }

  Future<void> _checkSavedSession() async {
    final token = await _apiClient.getToken();
    if (token != null && token.isNotEmpty) {
      try {
        _user = await _authService.getProfile();
        _isLoggedIn = true;
      } catch (_) {
        // Try refresh
        final refreshToken = await _apiClient.getRefreshToken();
        if (refreshToken != null) {
          try {
            final newToken = await _authService.refreshToken(refreshToken);
            await _apiClient.setToken(newToken);
            _user = await _authService.getProfile();
            _isLoggedIn = true;
          } catch (_) {
            await _apiClient.clearTokens();
          }
        } else {
          await _apiClient.clearTokens();
        }
      }
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        username: username,
        password: password,
      );
      await _apiClient.setToken(result.token);
      await _apiClient.setRefreshToken(result.refreshToken);
      await _saveLoginTime();
      _user = result.user;
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = '网络错误: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.register(
        username: username,
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = '网络错误: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    try {
      _user = await _authService.getProfile();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setAvatar(String? imageId) async {
    try {
      _user = await _authService.setAvatar(imageId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.forgotPassword(email);
      _isLoading = false;
      notifyListeners();
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = '网络错误: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _saveLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login-time', DateTime.now().toIso8601String());
  }
}
