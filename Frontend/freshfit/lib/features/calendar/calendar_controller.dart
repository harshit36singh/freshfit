import 'package:flutter/material.dart';
import '../outfit/models/outfit_model.dart';

class CalendarController extends ChangeNotifier {
  Map<DateTime, OutfitModel> _scheduledOutfits = {};
  DateTime _selectedDate = DateTime.now();

  Map<DateTime, OutfitModel> get scheduledOutfits => _scheduledOutfits;
  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void scheduleOutfit(DateTime date, OutfitModel outfit) {
    // Normalize date to midnight for consistent key
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _scheduledOutfits[normalizedDate] = outfit;
    notifyListeners();
  }

  void removeScheduledOutfit(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    _scheduledOutfits.remove(normalizedDate);
    notifyListeners();
  }

  OutfitModel? getOutfitForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _scheduledOutfits[normalizedDate];
  }

  bool hasOutfitOnDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _scheduledOutfits.containsKey(normalizedDate);
  }

  List<DateTime> getDatesWithOutfits() {
    return _scheduledOutfits.keys.toList();
  }

  Map<DateTime, OutfitModel> getOutfitsInRange(
    DateTime start,
    DateTime end,
  ) {
    return Map.fromEntries(
      _scheduledOutfits.entries.where((entry) {
        return entry.key.isAfter(start.subtract(const Duration(days: 1))) &&
            entry.key.isBefore(end.add(const Duration(days: 1)));
      }),
    );
  }
}