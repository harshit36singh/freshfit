import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  
  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
  
  // Sign up
  Future<bool> signup({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    
    try {
      final result = await ApiService.signup(
        email: email,
        password: password,
      );
      
      _isLoading = false;
      
      if (result['success']) {
        _successMessage = result['message'];
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred';
      notifyListeners();
      return false;
    }
  }
  
  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    
    try {
      final result = await ApiService.login(
        email: email,
        password: password,
      );
      
      _isLoading = false;
      
      if (result['success']) {
        // Save token and email
        await StorageService.saveToken(result['token']);
        await StorageService.saveEmail(email);
        
        _successMessage = result['message'];
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred';
      notifyListeners();
      return false;
    }
  }
  
  // Logout
  Future<void> logout() async {
    await StorageService.clearAll();
    notifyListeners();
  }
  
  // Check if user is logged in
  Future<bool> checkLoginStatus() async {
    return await StorageService.isLoggedIn();
  }
}