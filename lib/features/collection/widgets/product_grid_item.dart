import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/home_mock_data.dart';
import '../../../router/app_router.dart';

class ProductGridItem extends StatefulWidget {
  const ProductGridItem({super.key, required this.item});

  final GiftItem item;

  @override
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
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
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product image with favorite overlay
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: widget.item.accent.withOpacity(0.15),
                        child: Icon(
                          Icons.image_outlined,
                          size: 36,
                          color: widget.item.accent,
                        ),
                      ),
                    ),
                    if (widget.item.discount > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC0392B),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${widget.item.discount}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setState(() => _isLiked = !_isLiked),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xF2FFFFFF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 16,
                            color: _isLiked
                                ? const Color(0xFFC0392B)
                                : const Color(0xFF554B44),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Product Info
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2C261E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF7A6655),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.item.discount > 0)
                              Text(
                                widget.item.price,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                  color: const Color(0xFF9E7E5A),
                                ),
                              ),
                            Text(
                              widget.item.discount > 0
                                  ? '\$${((double.tryParse(widget.item.price.replaceAll('\$', '')) ?? 0.0) * (1 - widget.item.discount / 100)).toStringAsFixed(2)}'
                                  : widget.item.price,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF8C6500),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF5A623),
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '4.8',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF7A6655),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.productDetail,
                            arguments: ProductDetailArgs(item: widget.item),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD8AE73),
                          foregroundColor: const Color(0xFF4A321B),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Quick Add',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
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
