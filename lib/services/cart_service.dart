import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      'stock': item.stock,
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
  static const _base = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:3000/api');

  CartService() {
    _initCart();
  }

  final Map<String, CartItem> _items = {};
  String? _backendCartId;
  bool _isLoggedIn = false;

  List<CartItem> get items => _items.values.toList();
  bool get isEmpty => _items.isEmpty;
  bool get isLoggedIn => _isLoggedIn;
  int get itemCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);
  double get shipping => isEmpty ? 0.0 : 12.0;
  double get tax => subtotal * 0.08;
  double get total => subtotal + shipping + tax;

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<bool> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    _isLoggedIn = token != null && token.isNotEmpty;
    return _isLoggedIn;
  }

  /// Initialize cart: if logged in, fetch from backend; otherwise start empty.
  Future<void> _initCart() async {
    if (await _checkLoggedIn()) {
      await loadFromBackend();
    }
  }

  /// Fetch the user's cart from the backend and populate local state.
  Future<void> loadFromBackend() async {
    if (!await _checkLoggedIn()) return;
    try {
      final headers = await _authHeaders();

      // Try to get the user's cart; create one if it doesn't exist
      var res = await http.get(Uri.parse('$_base/carts/my'), headers: headers);

      if (res.statusCode == 404) {
        // No cart exists yet, create one
        res = await http.post(Uri.parse('$_base/carts'), headers: headers);
      }

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        _backendCartId = data['_id']?.toString() ?? data['id']?.toString();
        _items.clear();

        final backendItems = data['items'] as List<dynamic>? ?? [];
        for (final entry in backendItems) {
          final map = entry as Map<String, dynamic>;
          final productData = map['product_id'];
          if (productData is Map<String, dynamic>) {
            final product = GiftItem.fromJson(productData);
            final qty = map['quantity'] as int? ?? 1;
            final key = product.id.isNotEmpty ? product.id : product.title;
            _items[key] = CartItem(item: product, quantity: qty);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart from backend: $e');
    }
  }

  /// Returns an error message string, or null on success.
  /// Returns 'LOGIN_REQUIRED' if user is not logged in.
  String? addItem(GiftItem item, [int quantity = 1]) {
    if (!_isLoggedIn) return 'LOGIN_REQUIRED';
    if (item.stock <= 0) return 'Product is out of stock';
    final key = item.id.isNotEmpty ? item.id : item.title;
    final currentQty = _items.containsKey(key) ? _items[key]!.quantity : 0;
    if (currentQty + quantity > item.stock) {
      return 'Cannot add more than available stock (${item.stock})';
    }

    // Optimistic update
    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = CartItem(item: item, quantity: quantity);
    }
    notifyListeners();

    // Sync to backend
    _syncAddItem(item.id, _items[key]!.quantity);
    return null;
  }

  Future<void> _syncAddItem(String productId, int quantity) async {
    if (_backendCartId == null) return;
    try {
      final headers = await _authHeaders();
      await http.post(
        Uri.parse('$_base/carts/$_backendCartId/items'),
        headers: headers,
        body: jsonEncode({'product_id': productId, 'quantity': quantity}),
      );
    } catch (e) {
      debugPrint('Error syncing add item: $e');
    }
  }

  void removeItem(String id) {
    final item = _items[id];
    _items.remove(id);
    notifyListeners();

    // Sync to backend
    if (item != null) {
      _syncRemoveItem(item.item.id);
    }
  }

  Future<void> _syncRemoveItem(String productId) async {
    if (_backendCartId == null) return;
    try {
      final headers = await _authHeaders();
      await http.delete(
        Uri.parse('$_base/carts/$_backendCartId/items/$productId'),
        headers: headers,
      );
    } catch (e) {
      debugPrint('Error syncing remove item: $e');
    }
  }

  String? updateQuantity(String id, int quantity) {
    if (!_items.containsKey(id)) return null;
    if (quantity > _items[id]!.item.stock) {
      return 'Cannot add more than available stock (${_items[id]!.item.stock})';
    }

    if (quantity <= 0) {
      removeItem(id);
      return null;
    }

    // Optimistic update
    _items[id]!.quantity = quantity;
    notifyListeners();

    // Sync to backend
    _syncUpdateQuantity(_items[id]!.item.id, quantity);
    return null;
  }

  Future<void> _syncUpdateQuantity(String productId, int quantity) async {
    if (_backendCartId == null) return;
    try {
      final headers = await _authHeaders();
      await http.patch(
        Uri.parse('$_base/carts/$_backendCartId/items/$productId'),
        headers: headers,
        body: jsonEncode({'quantity': quantity}),
      );
    } catch (e) {
      debugPrint('Error syncing update quantity: $e');
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();

    // Sync to backend
    _syncClear();
  }

  Future<void> _syncClear() async {
    if (_backendCartId == null) return;
    try {
      final headers = await _authHeaders();
      await http.delete(
        Uri.parse('$_base/carts/$_backendCartId/clear'),
        headers: headers,
      );
    } catch (e) {
      debugPrint('Error syncing clear cart: $e');
    }
  }

  void reset() {
    _items.clear();
    _backendCartId = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
