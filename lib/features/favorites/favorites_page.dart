import 'package:flutter/material.dart';
import 'widgets/favorite_notifier.dart';
import 'widgets/favorite_item_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteProvider.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF6EE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFF231408)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Favourites',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF231408),
          ),
        ),
        centerTitle: true,
        actions: [
          if (favorites.items.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClearAll(context, favorites),
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: Color(0xFFC0392B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: AnimatedBuilder(
        animation: favorites,
        builder: (context, _) {
          if (favorites.items.isEmpty) {
            return _buildEmptyState(context);
          }

          return Column(
            children: [

              Padding(
                padding:
                    const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(children: [
                  Text(
                    '${favorites.items.length} saved items',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9E7E5A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: favorites.items.length,
                  itemBuilder: (context, index) {
                    final item = favorites.items[index];
                    return FavoriteItemCard(
                      item: item,
                      onRemove: () => favorites.remove(item),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1E7D5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 38,
              color: Color(0xFFB8770D),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No favourites yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF231408),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap the ♡ on any product to save it here.',
            style: TextStyle(
                fontSize: 13, color: Color(0xFF9E7E5A)),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB8770D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(
      BuildContext context, FavoriteNotifier favorites) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear All Favourites'),
        content: const Text(
            'Remove all saved items? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              for (final item in [...favorites.items]) {
                favorites.remove(item);
              }
            },
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B)),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
