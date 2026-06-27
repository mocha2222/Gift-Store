import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/home_mock_data.dart';

class FavoriteNotifier extends ChangeNotifier {
  static const _base = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:3000/api');

  final List<GiftItem> _items = [];
  bool _isLoggedIn = false;
  bool _loaded = false;

  List<GiftItem> get items => List.unmodifiable(_items);
  bool get isLoggedIn => _isLoggedIn;

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

  /// Load favorites from the backend. Safe to call multiple times.
  Future<void> loadFromBackend() async {
    if (!await _checkLoggedIn()) return;
    try {
      final headers = await _authHeaders();
      final res = await http.get(Uri.parse('$_base/favorites'), headers: headers);

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        _items.clear();
        for (final entry in data) {
          final map = entry as Map<String, dynamic>;
          final productData = map['product_id'];
          if (productData is Map<String, dynamic>) {
            _items.add(GiftItem.fromJson(productData));
          }
        }
        _loaded = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites from backend: $e');
    }
  }

  bool isFavorite(GiftItem item) {
    final itemId = item.id.isNotEmpty ? item.id : item.title;
    return _items.any((e) {
      final eId = e.id.isNotEmpty ? e.id : e.title;
      return eId == itemId;
    });
  }

  /// Returns 'LOGIN_REQUIRED' if user must log in, null on success.
  String? toggle(GiftItem item) {
    if (!_isLoggedIn) return 'LOGIN_REQUIRED';

    if (isFavorite(item)) {
      _items.removeWhere((e) {
        final eId = e.id.isNotEmpty ? e.id : e.title;
        final itemId = item.id.isNotEmpty ? item.id : item.title;
        return eId == itemId;
      });
      notifyListeners();
      _syncRemove(item.id);
    } else {
      _items.add(item);
      notifyListeners();
      _syncAdd(item.id);
    }
    return null;
  }

  /// Returns 'LOGIN_REQUIRED' if user must log in, null on success.
  String? remove(GiftItem item) {
    if (!_isLoggedIn) return 'LOGIN_REQUIRED';

    _items.removeWhere((e) {
      final eId = e.id.isNotEmpty ? e.id : e.title;
      final itemId = item.id.isNotEmpty ? item.id : item.title;
      return eId == itemId;
    });
    notifyListeners();
    _syncRemove(item.id);
    return null;
  }

  Future<void> _syncAdd(String productId) async {
    try {
      final headers = await _authHeaders();
      await http.post(
        Uri.parse('$_base/favorites/$productId'),
        headers: headers,
      );
    } catch (e) {
      debugPrint('Error syncing add favorite: $e');
    }
  }

  Future<void> _syncRemove(String productId) async {
    try {
      final headers = await _authHeaders();
      await http.delete(
        Uri.parse('$_base/favorites/$productId'),
        headers: headers,
      );
    } catch (e) {
      debugPrint('Error syncing remove favorite: $e');
    }
  }

  void reset() {
    _items.clear();
    _isLoggedIn = false;
    _loaded = false;
    notifyListeners();
  }
}

class FavoriteProvider extends InheritedNotifier<FavoriteNotifier> {
  const FavoriteProvider({
    super.key,
    required FavoriteNotifier notifier,
    required super.child,
  }) : super(notifier: notifier);

  static FavoriteNotifier of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<FavoriteProvider>();
    assert(result != null, 'No FavoriteProvider found in context');
    return result!.notifier!;
  }
}