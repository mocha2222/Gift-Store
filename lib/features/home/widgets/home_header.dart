import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F0E4),
        border: Border(
          bottom: BorderSide(color: Colors.brown.withAlpha(31)),
        ),
      ),
      child: Row(
        children: [
          _HeaderIconButton(
            icon: Icons.menu_rounded,
            onTap: () {},
          ),
          const Spacer(),
          Text(
            'Khmer Treasures',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  color: const Color(0xFF8C6500),
                ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _HeaderIconButton(
            icon: Icons.shopping_cart_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 26,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(icon, size: 30, color: const Color(0xFF8C6500)),
      ),
    );
  }
}
