class ClothModel {
  final int id;
  final String name;
  final String category;
  final String color;
  final String? brand;
  final String? size;
  final String? season;
  final String? imagePath;
  final String? imageUrl;
  final DateTime addedDate;
  final bool isFavorite;

  ClothModel({
    required this.id,
    required this.name,
    required this.category,
    required this.color,
    this.brand,
    this.size,
    this.season,
    this.imagePath,
    this.imageUrl,
    required this.addedDate,
    this.isFavorite = false,
  });

  ClothModel copyWith({
    int? id,
    String? name,
    String? category,
    String? color,
    String? brand,
    String? size,
    String? season,
    String? imagePath,
    String? imageUrl,
    DateTime? addedDate,
    bool? isFavorite,
  }) {
    return ClothModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      color: color ?? this.color,
      brand: brand ?? this.brand,
      size: size ?? this.size,
      season: season ?? this.season,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      addedDate: addedDate ?? this.addedDate,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory ClothModel.fromJson(Map<String, dynamic> json) {
    return ClothModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      color: json['color'],
      brand: json['brand'],
      size: json['size'],
      season: json['season'],
      imagePath: json['image_path'],
      imageUrl: json['image_url'],
      addedDate: DateTime.parse(json['created_at']),
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'color': color,
      'brand': brand,
      'size': size,
      'season': season,
      'image_path': imagePath,
      'image_url': imageUrl,
      'created_at': addedDate.toIso8601String(),
      'is_favorite': isFavorite,
    };
  }
}

// Categories matching backend
class ClothCategory {
  static const String tops = 'tops';
  static const String bottoms = 'bottoms';
  static const String outerwear = 'outerwear';
  static const String shoes = 'shoes';
  static const String accessories = 'accessories';

  static List<String> get all => [
        tops,
        bottoms,
        outerwear,
        shoes,
        accessories,
      ];
  
  static String getDisplayName(String category) {
    switch (category) {
      case tops:
        return 'Tops';
      case bottoms:
        return 'Bottoms';
      case outerwear:
        return 'Outerwear';
      case shoes:
        return 'Shoes';
      case accessories:
        return 'Accessories';
      default:
        return category;
    }
  }
}

// Seasons
class Season {
  static const String spring = 'Spring';
  static const String summer = 'Summer';
  static const String fall = 'Fall';
  static const String winter = 'Winter';
  static const String allYear = 'All Year';

  static List<String> get all => [
        spring,
        summer,
        fall,
        winter,
        allYear,
      ];
}