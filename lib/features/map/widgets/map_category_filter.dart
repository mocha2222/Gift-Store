import 'package:flutter/material.dart';

class MapCategoryFilter extends StatelessWidget {
  const MapCategoryFilter({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final String selected;
  final ValueChanged<String> onSelect;

  static const _categories = [
    ('All',     '🗺️'),
    ('Silk',    '🧵'),
    ('Silver',  '💎'),
    ('Wood',    '🪵'),
    ('Edible',  '🫙'),
    ('Jewelry', '📿'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final (label, emoji) = _categories[i];
          final isSelected = selected == label;
          return GestureDetector(
            onTap: () => onSelect(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFB8770D)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFB8770D)
                      : const Color(0xFFEAD5A8),
                ),
                boxShadow: isSelected
                    ? [BoxShadow(
                        color: const Color(0xFFB8770D).withOpacity(0.3),
                        blurRadius: 8, offset: const Offset(0, 3))]
                    : [],
              ),
              child: Text(
                '$emoji  $label',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF5E4A35),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}