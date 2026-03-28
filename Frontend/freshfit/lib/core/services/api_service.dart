import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'https://freshfit-backend.onrender.com';

  static const String signupEndpoint = '/auth/signup';
  static const String loginEndpoint = '/auth/login';
  static const String uploadClothEndpoint = '/wardrobe/with-image';
  static const String getWardrobeEndpoint = '/wardrobe/';
  static const String deleteClothEndpoint = '/wardrobe';
  static const String generateOutfitEndpoint = '/outfits/generate';
  static const String getOutfitsEndpoint = '/outfits/';
  static const String deleteOutfitEndpoint = '/outfits';

  // Sign up
  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$signupEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['detail'] ?? 'Signup failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': email, 'password': password},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': data['access_token'],
          'message': 'Login successful',
        };
      } else {
        return {'success': false, 'message': data['detail'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // Upload cloth with image
 static Future<Map<String, dynamic>> uploadCloth({
  required String token,
  required String name,
  required String category,
  required File imageFile,
}) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl$uploadClothEndpoint'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['name'] = name;
    request.fields['category'] = category;

    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final mimeParts = mimeType.split('/');
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType(mimeParts[0], mimeParts[1]),
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // ✅ Add this — print exact server response
    print('Upload status: ${response.statusCode}');
    print('Upload body: ${response.body}');

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      final data = jsonDecode(response.body);
      return {'success': false, 'message': data['detail'] ?? 'Upload failed'};
    }
  } catch (e) {
    // ✅ Add this — print exact exception
    print('Upload exception: $e');
    return {'success': false, 'message': e.toString()};
  }
}

  // Get wardrobe
  static Future<Map<String, dynamic>> getWardrobe(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$getWardrobeEndpoint'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to fetch wardrobe'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // Delete cloth
  static Future<Map<String, dynamic>> deleteCloth({
    required String token,
    required int clothId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$deleteClothEndpoint/$clothId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Cloth deleted'};
      } else {
        return {'success': false, 'message': 'Failed to delete cloth'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // Generate outfit
  static Future<Map<String, dynamic>> generateOutfit(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$generateOutfitEndpoint'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['detail'] ?? 'Failed to generate outfit'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // Get saved outfits
  static Future<Map<String, dynamic>> getOutfits(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$getOutfitsEndpoint'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Failed to fetch outfits'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }

  // Delete outfit
  static Future<Map<String, dynamic>> deleteOutfit({
    required String token,
    required String outfitId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$deleteOutfitEndpoint/$outfitId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'message': 'Failed to delete outfit'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again.'};
    }
  }
}