import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Update this with your actual backend URL
  static const String baseUrl = 'http://localhost:8000'; // Change to your backend URL
  
  // API endpoints
  static const String signupEndpoint = '/auth/signup';
  static const String loginEndpoint = '/auth/login';
  
  // Sign up user
  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$signupEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['detail'] ?? 'Signup failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }
  
  // Login user
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': data['access_token'],
          'message': 'Login successful',
        };
      } else {
        return {
          'success': false,
          'message': data['detail'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }
}