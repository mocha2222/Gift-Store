import 'dart:typed_data';

class ArtisanProductModel {
  final String     id;
  final String     title;
  final String     description;
  final String     price;
  final String     category;
  final String     imagePath;
  final String     culturalBackground;
  final String     materialInfo;
  final String     story;
  final int        stock;
  final int        discount;
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
    this.culturalBackground = '',
    this.materialInfo = '',
    this.story = '',
    this.stock = 0,
    this.discount = 0,
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
    String?     culturalBackground,
    String?     materialInfo,
    String?     story,
    int?        stock,
    int?        discount,
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
      culturalBackground: culturalBackground ?? this.culturalBackground,
      materialInfo: materialInfo ?? this.materialInfo,
      story:       story       ?? this.story,
      stock:       stock       ?? this.stock,
      discount:    discount    ?? this.discount,
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
    'culturalBackground': culturalBackground,
    'materialInfo': materialInfo,
    'story':       story,
    'stock':       stock,
    'discount':    discount,
    'isAvailable': isAvailable,
    'createdAt':   createdAt.toIso8601String(),
  };

  factory ArtisanProductModel.fromJson(Map<String, dynamic> json) {
    return ArtisanProductModel(
      id:          json['id'],
      title:       json['title'],
      description: json['description'],
      price:       json['price']?.toString() ?? '0',
      category:    json['category'] ?? 'Other',
      imagePath:   json['imagePath'] ?? '',
      culturalBackground: json['culturalBackground'] ?? '',
      materialInfo: json['materialInfo'] ?? '',
      story:       json['story'] ?? '',
      stock:       json['stock'] ?? 0,
      discount:    json['discount'] ?? json['discount_percentage'] ?? json['discountPercent'] ?? 0,
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