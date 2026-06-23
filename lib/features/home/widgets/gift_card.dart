import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../favorites/widgets/favorite_notifier.dart';
import '../../../data/home_mock_data.dart';
import '../../../router/app_router.dart';
import '../../../services/cart_service.dart';

class GiftCard extends StatefulWidget {
  const GiftCard({super.key, required this.item});

  final GiftItem item;

  @override
  State<GiftCard> createState() => _GiftCardState();
}

class _GiftCardState extends State<GiftCard> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoriteProvider.of(context);
    final isFav = favorites.isFavorite(widget.item);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.productDetail,
          arguments: ProductDetailArgs(item: widget.item),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDF8F0),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 240,
                    width: double.infinity,
                    child: Image.network(
                      widget.item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 240,
                        color: widget.item.accent.withOpacity(0.2),
                        child: Icon(
                          Icons.image_outlined,
                          size: 60,
                          color: widget.item.accent,
                        ),
                      ),
                    ),
                  ),
                  if (widget.item.discount > 0)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC0392B),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.item.discount}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => favorites.toggle(widget.item),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(
                          color: Color(0xF2FFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 20,
                          color: isFav
                              ? const Color(0xFFC0392B)
                              : const Color(0xFF554B44),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF7A6655),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (widget.item.discount > 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Text(
                              widget.item.price,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: const Color(0xFF9E7E5A),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        Text(
                          widget.item.discount > 0
                              ? '\$${((double.tryParse(widget.item.price.replaceAll('\$', '')) ?? 0.0) * (1 - widget.item.discount / 100)).toStringAsFixed(2)}'
                              : widget.item.price,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: const Color(0xFF8C6500),
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < 4
                                    ? Icons.star_rounded
                                    : Icons.star_half_rounded,
                                color: const Color(0xFFF5A623),
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF7A6655),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (widget.item.stock <= 0) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Out of Stock'),
                                content: const Text('This product is currently out of stock and cannot be added to the cart.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }
                          final error = context.read<CartService>().addItem(widget.item);
                          if (error != null) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Stock Limit Reached'),
                                content: Text(error),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added item to cart')),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: widget.item.stock <= 0 ? Colors.grey.shade400 : const Color(0xFFD8AE73),
                          foregroundColor: widget.item.stock <= 0 ? Colors.white : const Color(0xFF4A321B),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          widget.item.stock <= 0 ? 'Out of Stock' : 'Quick Add to Cart',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
