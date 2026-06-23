import 'package:flutter/material.dart';

class ProductActions extends StatelessWidget {
  const ProductActions({
    super.key,
    required this.quantity,
    required this.isFavorite,
    required this.isOutOfStock,
    required this.onDecrement,
    required this.onIncrement,
    required this.onToggleFavorite,
    required this.onAddToFavorites,
    required this.onAddToCart,
  });

  final int quantity;
  final bool isFavorite;
  final bool isOutOfStock;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onToggleFavorite;
  final VoidCallback onAddToFavorites;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF231408),
                ),
              ),
            ),
            _QuantityButton(
              icon: Icons.remove,
              onTap: onDecrement,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            _QuantityButton(
              icon: Icons.add,
              onTap: onIncrement,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onAddToFavorites,
                icon: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                ),
                label: const Text('Add to Favorites'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF8C6500),
                  side: const BorderSide(
                    color: Color(0xFFD7C1A0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: onAddToCart,
                icon: Icon(isOutOfStock ? Icons.remove_shopping_cart_outlined : Icons.shopping_bag_outlined),
                label: Text(isOutOfStock ? 'Out of Stock' : 'Add to Cart'),
                style: FilledButton.styleFrom(
                  backgroundColor: isOutOfStock ? Colors.grey.shade400 : const Color(0xFFB8770D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7EC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE3D3BE)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF8C6500)),
      ),
    );
  }
}
