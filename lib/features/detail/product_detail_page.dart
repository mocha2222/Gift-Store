import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/home_mock_data.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_footer_nav.dart';
import '../../widgets/app_header.dart';
import '../../services/cart_service.dart';
import '../favorites/widgets/favorite_notifier.dart';
import 'widgets/product_actions.dart';
import 'widgets/product_images.dart';
import 'widgets/product_reviews_section.dart';
import 'widgets/product_spec_tile.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.item});

  final GiftItem item;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedImage = 0;
  int _quantity = 1;

  late final List<String> _gallery;

  @override
  void initState() {
    super.initState();
    _gallery = <String>[
      widget.item.imageUrl,
      'https://images.unsplash.com/photo-1584916201218-f4242ceb4809?w=700&q=80',
      'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=700&q=80',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = <Color>[
      widget.item.accent,
      const Color(0xFFB8770D),
      const Color(0xFF7A4E2D),
    ];
    
    final favorites = FavoriteProvider.of(context);
    final isFavorite = favorites.isFavorite(widget.item);

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: const Color(0xFF231408),
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Product Detail',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF231408),
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          color: const Color(0xFF231408),
                        ),
                        IconButton(
                          onPressed: () => favorites.toggle(widget.item),
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
                          color: isFavorite
                              ? const Color(0xFFC0392B)
                              : const Color(0xFF231408),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductImages(
                          gallery: _gallery,
                          selectedIndex: _selectedImage,
                          onSelected: (index) =>
                              setState(() => _selectedImage = index),
                          colors: colors,
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            _Pill(label: 'Heritage Silk'),
                            _Pill(label: 'In Stock'),
                            _Pill(label: 'Handmade'),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          widget.item.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF231408),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              widget.item.discount > 0 
                                  ? '\$${((double.tryParse(widget.item.price.replaceAll('\$', '')) ?? 0.0) * (1 - widget.item.discount / 100)).toStringAsFixed(2)}'
                                  : widget.item.price,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFB8770D),
                              ),
                            ),
                            if (widget.item.discount > 0) ...[
                              const SizedBox(width: 12),
                              Text(
                                '\$${(double.tryParse(widget.item.price.replaceAll('\$', '')) ?? 0.0).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.brown.withOpacity(0.55),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7EC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE3D3BE),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    size: 16,
                                    color: Color(0xFFF5A623),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.9 (124)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF7A6655),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const _SectionTitle(title: 'Description'),
                        const SizedBox(height: 8),
                        Text(
                          widget.item.subtitle,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Color(0xFF4F453A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const _SectionTitle(
                          title: 'Cultural background / story',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.item.culturalBackground.isNotEmpty
                              ? widget.item.culturalBackground
                              : 'Inspired by Khmer weaving traditions, this piece reflects the warm color palette, patient handcraft, and symbolic patterns found in Cambodian artisan communities.',
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Color(0xFF4F453A),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const _SectionTitle(title: 'Product details'),
                        const SizedBox(height: 8),
                        ProductSpecTile(
                          icon: Icons.inventory_2_outlined,
                          title: 'Material information',
                          value: widget.item.materialInfo.isNotEmpty 
                              ? widget.item.materialInfo 
                              : 'Mulberry silk, hand-dyed with natural indigo and plant-based pigments',
                        ),
                        const SizedBox(height: 10),
                        if (widget.item.dimensions != null) ...[
                          ProductSpecTile(
                            icon: Icons.straighten_rounded,
                            title: 'Dimensions',
                            value: widget.item.dimensions!,
                          ),
                          const SizedBox(height: 10),
                        ],
                        ProductSpecTile(
                          icon: Icons.store_outlined,
                          title: 'Stock availability',
                          value: 'In stock (${widget.item.stock} left)',
                        ),
                        const SizedBox(height: 16),
                        ProductActions(
                          quantity: _quantity,
                          isFavorite: isFavorite,
                          onDecrement: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : () {},
                          onIncrement: () => setState(() => _quantity++),
                          onToggleFavorite: () =>
                              favorites.toggle(widget.item),
                          onAddToFavorites: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added to favorites'),
                              ),
                            );
                          },
                          onAddToCart: () {
                            context.read<CartService>().addItem(
                              widget.item,
                              _quantity,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added $_quantity item(s) to cart',
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        const _SectionTitle(title: 'Story behind this piece'),
                        const SizedBox(height: 8),
                        Text(
                          widget.item.story.isNotEmpty
                              ? widget.item.story
                              : 'Every thread reflects long-standing craftsmanship passed down through families in Cambodia, turning a gift into a piece of living culture.',
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Color(0xFF4F453A),
                          ),
                        ),
                        const SizedBox(height: 18),
                        ProductReviewsSection(reviews: widget.item.reviews),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(top: false, child: AppFooterNav(currentIndex: 0)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE3D3BE)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF7A6655),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF231408),
      ),
    );
  }
}
