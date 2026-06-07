import 'package:flutter/material.dart';
import 'artisan_product_model.dart';

class ArtisanProductCard extends StatelessWidget {
  const ArtisanProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
  });

  final ArtisanProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailability;

  static const _categoryColors = {
    'Silk':    Color(0xFF6B4C9A),
    'Silver':  Color(0xFF5B7FA6),
    'Wood':    Color(0xFF7A5230),
    'Edible':  Color(0xFF4A7C59),
    'Jewelry': Color(0xFFB8770D),
    'Other':   Color(0xFF9E7E5A),
  };

  Widget _buildImage(Color catColor) {

    if (product.imageBytes != null) {
      return Image.memory(product.imageBytes!, fit: BoxFit.cover);
    }

    if (product.imagePath.startsWith('http')) {
      return Image.network(product.imagePath, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(catColor));
    }

    return Image.asset(product.imagePath, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(catColor));
  }

  Widget _placeholder(Color catColor) => Container(
    color: catColor.withOpacity(0.15),
    child: Icon(Icons.image_outlined, color: catColor, size: 30),
  );

  @override
  Widget build(BuildContext context) {
    final catColor =
        _categoryColors[product.category] ?? const Color(0xFFB8770D);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16)),
            child: SizedBox(
              width: 90, height: 90,
              child: _buildImage(catColor),
            ),
          ),


          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
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
                      child: Text(product.category,
                          style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w700,
                            color: catColor,
                          )),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onToggleAvailability,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: product.isAvailable
                              ? const Color(0xFF1AA363).withOpacity(0.1)
                              : const Color(0xFFC0392B).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.isAvailable ? '● Active' : '● Hidden',
                          style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w700,
                            color: product.isAvailable
                                ? const Color(0xFF1AA363)
                                : const Color(0xFFC0392B),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 5),
                  Text(product.title,
                      style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: Color(0xFF231408),
                      ),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(product.description,
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9E7E5A)),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(children: [
                    Text(product.price,
                        style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800,
                          color: Color(0xFF8C6500),
                        )),
                    const Spacer(),
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1E7D5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.edit_outlined,
                            size: 15, color: Color(0xFFB8770D)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _confirmDelete(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            size: 15, color: Color(0xFFC0392B)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Remove "${product.title}" from your shop?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () { Navigator.pop(context); onDelete(); },
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}