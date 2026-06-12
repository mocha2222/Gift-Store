import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'discount_product_model.dart';
import '../../../router/app_router.dart';

class DiscountProductCard extends StatelessWidget {
  const DiscountProductCard({
    super.key,
    required this.discount,
  });

  final DiscountProduct discount;

  String _daysLeft() {
    final days = discount.expiresAt.difference(DateTime.now()).inDays;
    if (days == 0) return 'Expires today!';
    if (days == 1) return 'Expires tomorrow';
    return 'Expires in $days days';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.productDetail,
        arguments: ProductDetailArgs(item: discount.item),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFEAD5A8)),
          boxShadow: const [
            BoxShadow(color: Color(0x0D000000),
                blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18)),
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Image.network(
                      discount.item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 180,
                        color: discount.item.accent
                            .withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 12, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: discount.badgeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${discount.discountPercent}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _daysLeft(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(discount.item.title,
                      style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        color: Color(0xFF231408),
                      )),
                  const SizedBox(height: 4),
                  Text(discount.item.subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF9E7E5A)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),

                  Row(children: [
                    Text(
                      discount.discountedPrice,
                      style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900,
                        color: discount.badgeColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      discount.originalPrice,
                      style: const TextStyle(
                        fontSize: 13, color: Color(0xFF9E7E5A),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: discount.code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Code "${discount.code}" copied!'),
                            duration: const Duration(seconds: 2),
                            backgroundColor:
                                const Color(0xFFB8770D),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: discount.badgeColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: discount.badgeColor
                                .withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              discount.code,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: discount.badgeColor,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.copy_rounded,
                                size: 11,
                                color: discount.badgeColor),
                          ],
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: discount.badgeColor,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Add to Cart  ·  ${discount.discountedPrice}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}