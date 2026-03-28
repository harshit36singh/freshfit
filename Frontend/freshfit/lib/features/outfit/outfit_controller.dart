import 'package:flutter/material.dart';
import 'models/outfit_model.dart';
import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';

class OutfitController extends ChangeNotifier {
  List<OutfitModel> _outfits = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OutfitModel> get outfits => _outfits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch all saved outfits from backend
  Future<void> fetchOutfits() async {
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

      final result = await ApiService.getOutfits(token);

      if (result['success']) {
        final list = result['data'] as List;
        _outfits = list.map((json) => OutfitModel.fromJson(json)).toList();
      } else {
        _errorMessage = result['message'];
      }
    } catch (e) {
      _errorMessage = 'Failed to load outfits: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Generate outfit via backend
  Future<OutfitModel?> generateOutfit({String? occasion, String? season}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      if (token == null) {
        _errorMessage = 'Please login again';
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final result = await ApiService.generateOutfit(token);

      if (result['success']) {
        final outfit = OutfitModel.fromJson(result['data']);
        _outfits.insert(0, outfit);
        _isLoading = false;
        notifyListeners();
        return outfit;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Failed to generate outfit: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Delete outfit
  Future<bool> deleteOutfit(String id) async {
    try {
      final token = await StorageService.getToken();
      if (token == null) return false;

      final result = await ApiService.deleteOutfit(token: token, outfitId: id);
      if (result['success']) {
        _outfits.removeWhere((o) => o.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Toggle favorite (local only)
  void toggleFavorite(String id) {
    final index = _outfits.indexWhere((o) => o.id == id);
    if (index != -1) {
      _outfits[index] = _outfits[index].copyWith(
        isFavorite: !_outfits[index].isFavorite,
      );
      notifyListeners();
    }
  }

  void markAsWorn(String id) {
    final index = _outfits.indexWhere((o) => o.id == id);
    if (index != -1) {
      _outfits[index] = _outfits[index].copyWith(
        timesWorn: _outfits[index].timesWorn + 1,
        lastWorn: DateTime.now(),
      );
      notifyListeners();
    }
  }

  OutfitModel? getOutfitById(String id) {
    try {
      return _outfits.firstWhere((o) => o.id == id);
    } catch (e) {
      return null;
    }
  }

  List<OutfitModel> getFavorites() => _outfits.where((o) => o.isFavorite).toList();
}