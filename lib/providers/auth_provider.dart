import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService;

  AuthProvider(this._apiService) {
    // Listen to auth state changes
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(user) async {
    if (user != null) {
      String? token = await _authService.getIdToken();
      if (token != null) {
        _apiService.setAuthToken(token);
      }
    } else {
      // Clear the token if user signs out
      _apiService.setAuthToken('');
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    User? user = await _authService.signIn(email, password);
    if (user != null) {
      String? token = await _authService.getIdToken();
      if (token != null) {
        _apiService.setAuthToken(token);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> signUp(String email, String password) async {
    User? user = await _authService.signUp(email, password);
    if (user != null) {
      String? token = await _authService.getIdToken();
      if (token != null) {
        _apiService.setAuthToken(token);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  // Add other auth-related methods if needed
}
