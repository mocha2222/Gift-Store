import 'package:flutter/material.dart';
import '../../../data/home_mock_data.dart';

class DiscountProduct {
  final GiftItem item;
  final int discountPercent;
  final String originalPrice;
  final String code;
  final Color badgeColor;
  final DateTime expiresAt;

  const DiscountProduct({
    required this.item,
    required this.discountPercent,
    required this.originalPrice,
    required this.code,
    required this.badgeColor,
    required this.expiresAt,
  });

  String get discountedPrice {
    final original = double.tryParse(
            originalPrice.replaceAll('\$', '').replaceAll(',', '')) ??
        0;
    final discounted = original * (1 - discountPercent / 100);
    return '\$${discounted.toStringAsFixed(2)}';
  }

  /// Build a DiscountProduct from a GiftItem that has discount > 0.
  factory DiscountProduct.fromGiftItem(GiftItem item) {
    const colors = [
      Color(0xFFC0392B),
      Color(0xFF4A7C59),
      Color(0xFF8C6500),
      Color(0xFF2980B9),
      Color(0xFF6B4C9A),
    ];
    final colorIndex = item.id.hashCode.abs() % colors.length;

    return DiscountProduct(
      item: item,
      discountPercent: item.discount,
      originalPrice: item.price,
      code: 'SAVE${item.discount}',
      badgeColor: colors[colorIndex],
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );
  }
}