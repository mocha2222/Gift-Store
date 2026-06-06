import 'package:flutter/material.dart';
import 'map_mock_data.dart';
import 'shop_bottom_sheet.dart';

class NearbyShopCard extends StatelessWidget {
  const NearbyShopCard({super.key, required this.shop});

  final ShopLocation shop;

  static const _categoryColors = {
    'Silk':    Color(0xFF6B4C9A),
    'Silver':  Color(0xFF5B7FA6),
    'Wood':    Color(0xFF7A5230),
    'Edible':  Color(0xFF4A7C59),
    'Jewelry': Color(0xFFB8770D),
  };

  @override
  Widget build(BuildContext context) {
    final catColor = _categoryColors[shop.category] ?? const Color(0xFFB8770D);

    return GestureDetector(
      onTap: () => ShopBottomSheet.show(context, shop),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEAD5A8)),
          boxShadow: const [
            BoxShadow(color: Color(0x0A000000),
                blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 64, height: 64,
                child: Image.network(shop.imageUrl, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: catColor.withOpacity(0.2))),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: catColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(shop.category,
                          style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700,
                            color: catColor,
                          )),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: shop.isOpen
                            ? const Color(0xFF1AA363).withOpacity(0.1)
                            : const Color(0xFFC0392B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        shop.isOpen ? 'Open' : 'Closed',
                        style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700,
                          color: shop.isOpen
                              ? const Color(0xFF1AA363)
                              : const Color(0xFFC0392B),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 4),
                  Text(shop.name,
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: Color(0xFF231408),
                      )),
                  const SizedBox(height: 3),
                  Row(children: [
                    const Icon(Icons.location_on_outlined,
                        size: 12, color: Color(0xFF9E7E5A)),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(shop.address,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF9E7E5A))),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.near_me_outlined,
                        size: 12, color: Color(0xFFB8770D)),
                    const SizedBox(width: 3),
                    Text('${shop.distanceKm} km',
                        style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: Color(0xFFB8770D),
                        )),
                  ]),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFD4AF37), size: 20),
          ],
        ),
      ),
    );
  }
}