import 'package:flutter/material.dart';
import '../../../pages/cart_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F0E4),
        border: Border(bottom: BorderSide(color: Colors.brown.withAlpha(31))),
      ),
      child: Row(
        children: [
          _HeaderIconButton(
            icon: Icons.menu_rounded,
            onTap: () => Scaffold.of(context).openDrawer(),
          ),
          const Spacer(),
          Text(
            'Khmer Treasures',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 24,
              color: const Color(0xFF8C6500),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          _HeaderIconButton(
            icon: Icons.shopping_cart_outlined,
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const CartPage())),
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
      radius: 22,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Icon(icon, size: 24, color: const Color(0xFF8C6500)),
      ),
    );
  }
}
