import 'package:flutter/material.dart';
import 'map_mock_data.dart';

class ShopBottomSheet extends StatelessWidget {
  const ShopBottomSheet({super.key, required this.shop});

  final ShopLocation shop;

  static void show(BuildContext context, ShopLocation shop) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ShopBottomSheet(shop: shop),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFBF6EE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(shop.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFF0E1C7))),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xAA000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12, left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: shop.isOpen
                            ? const Color(0xFF1AA363)
                            : const Color(0xFFC0392B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        shop.isOpen ? '● Open Now' : '● Closed',
                        style: const TextStyle(
                          color: Colors.white, fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop.name,
                    style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800,
                      color: Color(0xFF231408),
                    )),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: Color(0xFF9E7E5A)),
                  const SizedBox(width: 4),
                  Text(shop.address,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF9E7E5A))),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.access_time_rounded,
                      size: 14, color: Color(0xFF9E7E5A)),
                  const SizedBox(width: 4),
                  Text(shop.openHours,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF9E7E5A))),
                  const Spacer(),
                  ...List.generate(5, (i) => Icon(
                    i < shop.rating.floor()
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 14, color: const Color(0xFFF5A623),
                  )),
                  const SizedBox(width: 4),
                  Text('${shop.rating}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF7A6655),
                          fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 20),

                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.call_outlined, size: 16),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFB8770D),
                        side: const BorderSide(color: Color(0xFFEAD5A8)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.directions_rounded, size: 16),
                      label: const Text('Directions'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFB8770D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}