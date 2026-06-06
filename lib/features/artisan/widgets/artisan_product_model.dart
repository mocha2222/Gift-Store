import 'dart:typed_data';

class ArtisanProductModel {
  final String     id;
  final String     title;
  final String     description;
  final String     price;
  final String     category;
  final String     imagePath;
  final bool       isAvailable;
  final DateTime   createdAt;
  final Uint8List? imageBytes;

  ArtisanProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imagePath,
    this.isAvailable = true,
    this.imageBytes,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ArtisanProductModel copyWith({
    String?     title,
    String?     description,
    String?     price,
    String?     category,
    String?     imagePath,
    bool?       isAvailable,
    Uint8List?  imageBytes,
  }) {
    return ArtisanProductModel(
      id:          id,
      title:       title       ?? this.title,
      description: description ?? this.description,
      price:       price       ?? this.price,
      category:    category    ?? this.category,
      imagePath:   imagePath   ?? this.imagePath,
      isAvailable: isAvailable ?? this.isAvailable,
      imageBytes:  imageBytes  ?? this.imageBytes,
      createdAt:   createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':          id,
    'title':       title,
    'description': description,
    'price':       price,
    'category':    category,
    'imagePath':   imagePath,
    'isAvailable': isAvailable,
    'createdAt':   createdAt.toIso8601String(),
  };

  factory ArtisanProductModel.fromJson(Map<String, dynamic> json) {
    return ArtisanProductModel(
      id:          json['id'],
      title:       json['title'],
      description: json['description'],
      price:       json['price'],
      category:    json['category'],
      imagePath:   json['imagePath'],
      isAvailable: json['isAvailable'] ?? true,
      createdAt:   DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

const artisanCategories = [
  'Silk',
  'Silver',
  'Wood',
  'Edible',
  'Jewelry',
  'Other',
];