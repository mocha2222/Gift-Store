import 'package:flutter/material.dart';
import '../data/home_mock_data.dart';

class CartItem {
  CartItem({required this.item, required this.quantity});

  final GiftItem item;
  int quantity;

  String get id => item.id.isNotEmpty ? item.id : item.title;
  double get unitPrice => _parsePrice(item.price);
  double get totalPrice => unitPrice * quantity;

  static double _parsePrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0;
  }
}

class CartService extends ChangeNotifier {
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

  void addItem(GiftItem item, [int quantity = 1]) {
    final key = item.id.isNotEmpty ? item.id : item.title;
    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = CartItem(item: item, quantity: quantity);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    if (!_items.containsKey(id)) return;
    if (quantity <= 0) {
      _items.remove(id);
    } else {
      _items[id]!.quantity = quantity;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
