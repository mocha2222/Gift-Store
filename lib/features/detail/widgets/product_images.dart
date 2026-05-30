import 'package:flutter/material.dart';

class ProductImages extends StatelessWidget {
  const ProductImages({
    super.key,
    required this.gallery,
    required this.selectedIndex,
    required this.onSelected,
    required this.colors,
  });

  final List<String> gallery;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              gallery[selectedIndex],
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: colors[selectedIndex].withOpacity(0.18),
                child: Icon(
                  Icons.image_outlined,
                  size: 72,
                  color: colors[selectedIndex],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: gallery.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onSelected(index),
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selectedIndex == index
                          ? const Color(0xFF8C6500)
                          : const Color(0xFFE3D3BE),
                      width: selectedIndex == index ? 2 : 1,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(gallery[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
