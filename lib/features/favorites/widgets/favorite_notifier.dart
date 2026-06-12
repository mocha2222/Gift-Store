import 'package:flutter/material.dart';
import '../../../data/home_mock_data.dart';

class FavoriteNotifier extends ChangeNotifier {
  final List<GiftItem> _items = [];

  List<GiftItem> get items => List.unmodifiable(_items);

  bool isFavorite(GiftItem item) =>
      _items.any((e) => e.title == item.title);

  void toggle(GiftItem item) {
    if (isFavorite(item)) {
      _items.removeWhere((e) => e.title == item.title);
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void remove(GiftItem item) {
    _items.removeWhere((e) => e.title == item.title);
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