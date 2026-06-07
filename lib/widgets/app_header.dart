import 'package:flutter/material.dart';
import '../router/app_router.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.showCart = true,
    this.showMenu = true,
    this.title = 'Khmer Treasures',
    this.actions,
  });

  final bool showCart;
  final bool showMenu;
  final String title;
  final List<Widget>? actions;

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
          if (showMenu)
            HeaderIconButton(
              icon: Icons.menu_rounded,
              onTap: () => Scaffold.of(context).openDrawer(),
            )
          else
            const SizedBox(width: 36),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 24,
              color: const Color(0xFF8C6500),
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (actions != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            )
          else if (showCart)
            HeaderIconButton(
              icon: Icons.shopping_cart_outlined,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.cart),
            )
          else
            const SizedBox(width: 36),
        ],
      ),
    );
  }
}

class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({super.key, required this.icon, required this.onTap});

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
