import 'dart:convert';
import 'package:flutter/material.dart';

class DisciplineItem {
  final IconData icon;
  final String label;
  const DisciplineItem({required this.icon, required this.label});
}

const disciplines = [
  DisciplineItem(icon: Icons.waves_rounded, label: 'Silk'),
  DisciplineItem(icon: Icons.diamond_outlined, label: 'Silver'),
  DisciplineItem(icon: Icons.park_outlined, label: 'Wood'),
  DisciplineItem(icon: Icons.spa_outlined, label: 'Edible'),
  DisciplineItem(icon: Icons.auto_awesome_outlined, label: 'Jewelry'),
];

class GiftItem {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final Color accent;
  final String? dimensions;
  final List<ProductReview> reviews;
  final String story;
  final String culturalBackground;
  final String materialInfo;
  final int stock;
  final int discount;
  final String category;
  final String? categoryId;
  final String? categoryName;

  const GiftItem({
    this.id = '',
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.accent,
    this.dimensions,
    this.reviews = const [],
    this.story = '',
    this.culturalBackground = '',
    this.materialInfo = '',
    this.stock = 10,
    this.discount = 0,
    this.category = 'Other',
    this.categoryId,
    this.categoryName,
  });

  factory GiftItem.fromJson(Map<String, dynamic> json) {
    const accents = [
      Color(0xFF6B4C9A),
      Color(0xFF5B7FA6),
      Color(0xFF4A7C59),
      Color(0xFF7A5230),
      Color(0xFFC0392B),
    ];
    final colorHashCode = (json['_id']?.hashCode ?? json['id']?.hashCode ?? 0).abs();
    
    String? catId;
    String? catName;
    if (json['category_id'] != null) {
      if (json['category_id'] is Map) {
        catId = json['category_id']['_id']?.toString() ?? json['category_id']['id']?.toString();
        catName = json['category_id']['category_name']?.toString();
      } else {
        catId = json['category_id'].toString();
      }
    }

    final rawId = json['_id']?.toString() ?? '';
    final fallbackId = json['id']?.toString() ?? '';

    return GiftItem(
      id: rawId.isNotEmpty ? rawId : fallbackId,
      title: json['name']?.toString() ?? 'Unnamed Product',
      subtitle: json['description']?.toString() ?? '',
      price: '\$${json['price']?.toString() ?? '0.00'}',
      imageUrl: json['image']?.toString() ?? '',
      accent: accents[colorHashCode % accents.length],
      dimensions: json['dimensions']?.toString(),
      story: json['story']?.toString() ?? '',
      culturalBackground: json['cultural_background']?.toString() ?? '',
      materialInfo: json['material_info']?.toString() ?? '',
      stock: json['stock'] is int ? json['stock'] : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      discount: (json['discount'] ?? json['discount_percentage'] ?? json['discountPercent']) is int 
          ? (json['discount'] ?? json['discount_percentage'] ?? json['discountPercent']) 
          : int.tryParse((json['discount'] ?? json['discount_percentage'] ?? json['discountPercent'])?.toString() ?? '0') ?? 0,
      category: json['category_id'] is Map ? (json['category_id']['category_name']?.toString() ?? 'Other') : 'Other',
      categoryId: catId,
      categoryName: catName,
    );
  }
}

class ProductReview {
  final String name;
  final String location;
  final double rating;
  final String comment;
  final String avatarUrl;

  const ProductReview({
    required this.name,
    required this.location,
    required this.rating,
    required this.comment,
    required this.avatarUrl,
  });
}

class PromoItem {
  final String title;
  final String code;
  final String description;
  final int discountPercent;
  final Color color;
  const PromoItem({
    required this.title,
    required this.code,
    required this.description,
    required this.discountPercent,
    required this.color,
  });

  factory PromoItem.fromJson(Map<String, dynamic> json) {
    const colors = [
      Color(0xFFC0392B),
      Color(0xFF8C6500),
      Color(0xFF4A7C59),
      Color(0xFF2980B9),
      Color(0xFF6B4C9A),
    ];
    final code = json['code']?.toString() ?? '';
    final colorIndex = code.hashCode.abs() % colors.length;

    return PromoItem(
      title: '${json['code'] ?? 'PROMO'} 🎁',
      code: code,
      description: '${json['discount'] ?? 0}% off — use code $code',
      discountPercent: json['discount'] is int ? json['discount'] : int.tryParse(json['discount']?.toString() ?? '0') ?? 0,
      color: colors[colorIndex],
    );
  }
}

class CollectionItem {
  final String id;
  final String name;
  final String occasion;
  final String itemCount;
  final String imageUrl;
  const CollectionItem({
    this.id = '',
    required this.name,
    required this.occasion,
    required this.itemCount,
    required this.imageUrl,
  });

  factory CollectionItem.fromJson(Map<String, dynamic> json) {
    return CollectionItem(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['title']?.toString() ?? 'Untitled',
      occasion: json['description']?.toString() ?? '',
      itemCount: '',
      imageUrl: json['cover_image']?.toString() ?? '',
    );
  }

  Widget buildImage({BoxFit fit = BoxFit.cover, double? width, double? height}) {
    if (imageUrl.isEmpty) {
      return Container(color: const Color(0xFFF1E7D5), child: const Icon(Icons.image, color: Color(0xFF8C6500)));
    }
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF1E7D5), child: const Icon(Icons.image, color: Color(0xFF8C6500))),
      );
    }
    try {
      String cleanBase64 = imageUrl;
      if (imageUrl.contains(',')) {
        cleanBase64 = imageUrl.split(',')[1];
      }
      final bytes = base64Decode(cleanBase64);
      return Image.memory(
        bytes,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF1E7D5), child: const Icon(Icons.image, color: Color(0xFF8C6500))),
      );
    } catch (_) {
      return Container(color: const Color(0xFFF1E7D5), child: const Icon(Icons.image, color: Color(0xFF8C6500)));
    }
  }
}

class ArtisanProduct {
  final String title;
  final String price;
  final String imagePath;

  const ArtisanProduct({
    required this.title,
    required this.price,
    required this.imagePath,
  });

  Map<String, String> toJson() => {
    'title': title,
    'price': price,
    'imagePath': imagePath,
  };

  factory ArtisanProduct.fromJson(Map<String, dynamic> json) {
    return ArtisanProduct(
      title: json['title']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? '',
    );
  }
}

class MakerItem {
  final String id;
  final String name;
  final String role;
  final String quote;
  final String avatarUrl;
  final int followerCount;
  final List<ArtisanProduct> products;
  const MakerItem({
    this.id = '',
    required this.name,
    required this.role,
    required this.quote,
    required this.avatarUrl,
    required this.followerCount,
    required this.products,
  });
}
