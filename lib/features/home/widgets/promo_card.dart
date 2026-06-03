import 'package:flutter/material.dart';
import '../../../data/home_mock_data.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({super.key, required this.item});

  final PromoItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${item.discountPercent}% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.local_offer_rounded, color: item.color, size: 16),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF231408),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9E7E5A),
              height: 1.4,
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1E7D5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: item.color.withOpacity(0.35)),
            ),
            child: Text(
              item.code,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: item.color,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}