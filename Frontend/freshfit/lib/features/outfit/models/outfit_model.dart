import 'package:freshfit/features/wardrobe/models/cloth_model.dart';


class OutfitModel {
  final String id;
  final String name;
  final List<ClothModel> clothes;
  final DateTime createdDate;
  final String? occasion;
  final String? season;
  final bool isFavorite;
  final int timesWorn;
  final DateTime? lastWorn;

  OutfitModel({
    required this.id,
    required this.name,
    required this.clothes,
    required this.createdDate,
    this.occasion,
    this.season,
    this.isFavorite = false,
    this.timesWorn = 0,
    this.lastWorn,
  });

  OutfitModel copyWith({
    String? id,
    String? name,
    List<ClothModel>? clothes,
    DateTime? createdDate,
    String? occasion,
    String? season,
    bool? isFavorite,
    int? timesWorn,
    DateTime? lastWorn,
  }) {
    return OutfitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      clothes: clothes ?? this.clothes,
      createdDate: createdDate ?? this.createdDate,
      occasion: occasion ?? this.occasion,
      season: season ?? this.season,
      isFavorite: isFavorite ?? this.isFavorite,
      timesWorn: timesWorn ?? this.timesWorn,
      lastWorn: lastWorn ?? this.lastWorn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'clothes': clothes.map((c) => c.toJson()).toList(),
      'createdDate': createdDate.toIso8601String(),
      'occasion': occasion,
      'season': season,
      'isFavorite': isFavorite,
      'timesWorn': timesWorn,
      'lastWorn': lastWorn?.toIso8601String(),
    };
  }

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    return OutfitModel(
      id: json['id'],
      name: json['name'],
      clothes: (json['clothes'] as List)
          .map((c) => ClothModel.fromJson(c))
          .toList(),
      createdDate: DateTime.parse(json['createdDate']),
      occasion: json['occasion'],
      season: json['season'],
      isFavorite: json['isFavorite'] ?? false,
      timesWorn: json['timesWorn'] ?? 0,
      lastWorn: json['lastWorn'] != null
          ? DateTime.parse(json['lastWorn'])
          : null,
    );
  }
}

// Occasions
class Occasion {
  static const String casual = 'Casual';
  static const String formal = 'Formal';
  static const String business = 'Business';
  static const String party = 'Party';
  static const String sports = 'Sports';
  static const String date = 'Date';
  static const String vacation = 'Vacation';

  static List<String> get all => [
        casual,
        formal,
        business,
        party,
        sports,
        date,
        vacation,
      ];
}