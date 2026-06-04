import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../admin_models.dart';

class ProductToolbar extends StatelessWidget {
  const ProductToolbar({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.w700, color: const Color(0xFF231408))),
          const SizedBox(height: 6),
          Text(subtitle, style: GoogleFonts.inter(height: 1.5, color: const Color(0xFF6B5D4F))),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onDelete});

  final AdminProduct product;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final stockColor = product.stock > 10 ? const Color(0xFF2E7D32) : const Color(0xFFC0392B);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2D3BE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: GoogleFonts.cormorantGaramond(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF231408))),
                    const SizedBox(height: 4),
                    Text(product.artisan, style: GoogleFonts.inter(color: const Color(0xFF7A6655))),
                  ],
                ),
              ),
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFC0392B))),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ProductPill(label: product.category),
              ProductPill(label: product.isFeatured ? 'Featured' : 'Standard'),
              ProductPill(label: '\$${product.price.toStringAsFixed(2)}'),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: 18, color: stockColor),
              const SizedBox(width: 6),
              Text('${product.stock} in stock', style: GoogleFonts.inter(color: stockColor, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductPill extends StatelessWidget {
  const ProductPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E7D5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: const Color(0xFF7A4E2D))),
    );
  }
}
