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
}

final discountProducts = [
  DiscountProduct(
    item: trendingGifts[0],
    discountPercent: 20,
    originalPrice: trendingGifts[0].price,
    code: 'BONN20',
    badgeColor: const Color(0xFFC0392B),
    expiresAt: DateTime.now().add(const Duration(days: 5)),
  ),
  DiscountProduct(
    item: trendingGifts[3], 
    discountPercent: 25,
    originalPrice: trendingGifts[3].price,
    code: 'FIRSTGIFT25',
    badgeColor: const Color(0xFF4A7C59),
    expiresAt: DateTime.now().add(const Duration(days: 14)),
  ),
  DiscountProduct(
    item: trendingGifts[1], 
    discountPercent: 10,
    originalPrice: trendingGifts[1].price,
    code: 'WEDDING10',
    badgeColor: const Color(0xFF8C6500),
    expiresAt: DateTime.now().add(const Duration(days: 30)),
  ),
  DiscountProduct(
    item: trendingGifts[2], 
    discountPercent: 15,
    originalPrice: trendingGifts[2].price,
    code: 'PEPPER15',
    badgeColor: const Color(0xFF2980B9),
    expiresAt: DateTime.now().add(const Duration(days: 7)),
  ),
];