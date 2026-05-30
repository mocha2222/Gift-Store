import 'package:flutter/material.dart';

class AppFooterNav extends StatelessWidget {
  const AppFooterNav({super.key, this.currentIndex = 0});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final items = <({IconData icon, String label})>[
      (icon: Icons.home_rounded, label: 'Home'),
      (icon: Icons.explore_outlined, label: 'Explore'),
      (icon: Icons.favorite_border_rounded, label: 'Favorites'),
      (icon: Icons.location_on_outlined, label: 'Nearby'),
      (icon: Icons.person_outline_rounded, label: 'Profile'),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EEE2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2D3BE)),
      ),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++)
            Expanded(
              child: _FooterItem(
                icon: items[index].icon,
                label: items[index].label,
                selected: index == currentIndex,
              ),
            ),
        ],
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  const _FooterItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final background = selected ? const Color(0xFFF1C766) : Colors.transparent;
    final foreground = selected ? const Color(0xFF7B5200) : const Color(0xFF5E554B);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: foreground,
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}
