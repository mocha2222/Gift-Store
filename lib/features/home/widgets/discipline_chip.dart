import 'package:flutter/material.dart';
import '../../../data/home_mock_data.dart';

class DisciplineChip extends StatelessWidget {
  const DisciplineChip({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final DisciplineItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFD8AE73)
                  : const Color(0xFFF1E7D5),
              shape: BoxShape.circle,
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFD8AE73).withOpacity(0.45),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              item.icon,
              color: selected
                  ? const Color(0xFF4A321B)
                  : const Color(0xFF8C6500),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected
                      ? const Color(0xFF8C6500)
                      : const Color(0xFF4F453A),
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}