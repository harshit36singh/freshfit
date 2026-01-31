import 'dart:io';
import 'package:flutter/material.dart';
import 'models/cloth_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';

class WardrobeController extends ChangeNotifier {
  List<ClothModel> _allClothes = [];
  List<ClothModel> _filteredClothes = [];
  String? _selectedCategory;
  bool _showFavoritesOnly = false;
  bool _isLoading = false;
  String? _errorMessage;

  List<ClothModel> get allClothes => _allClothes;
  List<ClothModel> get filteredClothes => _filteredClothes;
  String? get selectedCategory => _selectedCategory;
  bool get showFavoritesOnly => _showFavoritesOnly;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch wardrobe from backend
  Future<void> fetchWardrobe() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      if (token == null) {
        _errorMessage = 'Please login again';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final result = await ApiService.getWardrobe(token);
      
      if (result['success']) {
        final clothesList = result['data'] as List;
        _allClothes = clothesList.map((json) => ClothModel.fromJson(json)).toList();
        _applyFilters();
      } else {
        _errorMessage = result['message'];
      }
    } catch (e) {
      _errorMessage = 'Failed to load wardrobe: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Add cloth with backend
  Future<bool> addCloth({
    required String name,
    required String category,
    required File imageFile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      if (token == null) {
        _errorMessage = 'Please login again';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final result = await ApiService.uploadCloth(
        token: token,
        name: name,
        category: category,
        imageFile: imageFile,
      );

      if (result['success']) {
        final cloth = ClothModel.fromJson(result['data']);
        _allClothes.add(cloth);
        _applyFilters();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to add cloth: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete cloth
  Future<bool> deleteCloth(int clothId) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) return false;

      final result = await ApiService.deleteCloth(token: token, clothId: clothId);

      if (result['success']) {
        _allClothes.removeWhere((c) => c.id == clothId);
        _applyFilters();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Toggle favorite (local only for now)
  void toggleFavorite(int id) {
    final index = _allClothes.indexWhere((c) => c.id == id);
    if (index != -1) {
      _allClothes[index] = _allClothes[index].copyWith(
        isFavorite: !_allClothes[index].isFavorite,
      );
      _applyFilters();
      notifyListeners();
    }
  }

  // Toggle favorites filter
  void toggleFavoritesOnly() {
    _showFavoritesOnly = !_showFavoritesOnly;
    _applyFilters();
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _showFavoritesOnly = false;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredClothes = _allClothes.where((cloth) {
      bool matchesCategory = _selectedCategory == null ||
          cloth.category == _selectedCategory;
      bool matchesFavorite = !_showFavoritesOnly || cloth.isFavorite;
      return matchesCategory && matchesFavorite;
    }).toList();
  }

  List<ClothModel> getFavorites() {
    return _allClothes.where((c) => c.isFavorite).toList();
  }

  ClothModel? getClothById(int id) {
    try {
      return _allClothes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}