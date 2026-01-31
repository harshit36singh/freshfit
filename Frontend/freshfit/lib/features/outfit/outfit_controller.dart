import 'package:flutter/material.dart';
import 'models/outfit_model.dart';
import '../wardrobe/models/cloth_model.dart';

class OutfitController extends ChangeNotifier {
  List<OutfitModel> _outfits = [];
  List<OutfitModel> _filteredOutfits = [];

  List<OutfitModel> get outfits => _outfits;
  List<OutfitModel> get filteredOutfits => _filteredOutfits;

  void addOutfit(OutfitModel outfit) {
    _outfits.add(outfit);
    _filteredOutfits = _outfits;
    notifyListeners();
  }

  void updateOutfit(OutfitModel outfit) {
    final index = _outfits.indexWhere((o) => o.id == outfit.id);
    if (index != -1) {
      _outfits[index] = outfit;
      _filteredOutfits = _outfits;
      notifyListeners();
    }
  }

  void deleteOutfit(String id) {
    _outfits.removeWhere((o) => o.id == id);
    _filteredOutfits = _outfits;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _outfits.indexWhere((o) => o.id == id);
    if (index != -1) {
      _outfits[index] = _outfits[index].copyWith(
        isFavorite: !_outfits[index].isFavorite,
      );
      _filteredOutfits = _outfits;
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
      _filteredOutfits = _outfits;
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

  List<OutfitModel> getFavorites() {
    return _outfits.where((o) => o.isFavorite).toList();
  }

  List<OutfitModel> getByOccasion(String occasion) {
    return _outfits.where((o) => o.occasion == occasion).toList();
  }

  // Generate outfit suggestion based on available clothes and occasion
  OutfitModel? generateOutfit({
    required List<ClothModel> availableClothes,
    String? occasion,
    String? season,
  }) {
    // Simple algorithm to suggest outfit
    final tops = availableClothes
        .where((c) => c.category == ClothCategory.tops)
        .toList();
    final bottoms = availableClothes
        .where((c) => c.category == ClothCategory.bottoms)
        .toList();
    final shoes = availableClothes
        .where((c) => c.category == ClothCategory.shoes)
        .toList();

    if (tops.isEmpty || bottoms.isEmpty || shoes.isEmpty) {
      return null;
    }

    // Pick random items (in a real app, use AI/ML for better matching)
    final selectedClothes = [
      tops[0],
      bottoms[0],
      shoes[0],
    ];

    return OutfitModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Generated Outfit',
      clothes: selectedClothes,
      createdDate: DateTime.now(),
      occasion: occasion,
      season: season,
    );
  }
}