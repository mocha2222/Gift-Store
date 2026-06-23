import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/home_mock_data.dart';

class CartItem {
  CartItem({required this.item, required this.quantity});

  final GiftItem item;
  int quantity;

  String get id => item.id.isNotEmpty ? item.id : item.title;
  double get unitPrice {
    final basePrice = _parsePrice(item.price);
    if (item.discount > 0) {
      return basePrice * (1 - item.discount / 100);
    }
    return basePrice;
  }
  double get totalPrice => unitPrice * quantity;

  static double _parsePrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }

  Map<String, dynamic> toJson() => {
    'item_id': item.id,
    'quantity': quantity,
    'item_data': {
      '_id': item.id,
      'name': item.title,
      'description': item.subtitle,
      'price': unitPrice.toString(),
      'image': item.imageUrl,
      'discount': item.discount,
      'category_id': item.categoryId,
    }
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      item: GiftItem.fromJson(json['item_data'] as Map<String, dynamic>),
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}

class CartService extends ChangeNotifier {
  CartService() {
    _loadCart();
  }

  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  bool get isEmpty => _items.isEmpty;
  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);
  double get shipping => isEmpty ? 0.0 : 12.0;
  double get tax => subtotal * 0.08;
  double get total => subtotal + shipping + tax;

  static final _mongoIdRegex = RegExp(r'^[a-fA-F0-9]{24}$');

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('cart_items');
      if (cartJson != null && cartJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(cartJson);
        bool hadInvalid = false;
        for (final entry in decoded) {
          final item = CartItem.fromJson(entry as Map<String, dynamic>);
          // Skip items with empty or non-MongoDB IDs (stale mock data)
          if (!_mongoIdRegex.hasMatch(item.item.id)) {
            debugPrint('[Cart] Skipping stale cart item with invalid id="${item.item.id}" title="${item.item.title}"');
            hadInvalid = true;
            continue;
          }
          _items[item.id] = item;
        }
        if (hadInvalid) {
          // Re-save cart without the invalid items
          _saveCart();
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> list = _items.values.map((item) => item.toJson()).toList();
      await prefs.setString('cart_items', jsonEncode(list));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  String? addItem(GiftItem item, [int quantity = 1]) {
    if (item.stock <= 0) return 'Product is out of stock';
    final key = item.id.isNotEmpty ? item.id : item.title;
    final currentQty = _items.containsKey(key) ? _items[key]!.quantity : 0;
    if (currentQty + quantity > item.stock) {
      return 'Cannot add more than available stock (${item.stock})';
    }
    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = CartItem(item: item, quantity: quantity);
    }
    _saveCart();
    notifyListeners();
    return null;
  }

  void removeItem(String id) {
    _items.remove(id);
    _saveCart();
    notifyListeners();
  }

  String? updateQuantity(String id, int quantity) {
    if (!_items.containsKey(id)) return null;
    if (quantity > _items[id]!.item.stock) {
      return 'Cannot add more than available stock (${_items[id]!.item.stock})';
    }
    if (quantity <= 0) {
      _items.remove(id);
    } else {
      _items[id]!.quantity = quantity;
    }
    _saveCart();
    notifyListeners();
    return null;
  }

  void clear() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }
}
