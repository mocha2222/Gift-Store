import 'package:flutter/material.dart';

class ArtisanDashboardHeader extends StatelessWidget {
  const ArtisanDashboardHeader({
    super.key,
    required this.name,
    required this.craft,
    required this.productCount,
    required this.onLogout,
  });

  final String name;
  final String craft;
  final int productCount;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8770D).withValues(alpha: 0.3),
            blurRadius: 16, offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5), width: 2),
                ),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'A',
                    style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        )),
                    Text(name,
                        style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800,
                          color: Colors.white,
                        )),
                    Text(craft,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        )),
                  ],
                ),
              ),
              IconButton(
                onPressed: onLogout,
                icon: const Icon(Icons.logout_rounded,
                    color: Colors.white, size: 20),
                tooltip: 'Sign out',
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(children: [
            _StatChip(
              label: 'Products',
              value: '$productCount',
              icon: Icons.inventory_2_outlined,
            ),
            const SizedBox(width: 10),
            const _StatChip(
              label: 'Orders',
              value: '—',
              icon: Icons.shopping_bag_outlined,
            ),
            const SizedBox(width: 10),
            const _StatChip(
              label: 'Reviews',
              value: '—',
              icon: Icons.star_outline_rounded,
            ),
          ]),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800,
                  color: Colors.white,
                )),
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.8),
                )),
          ],
        ),
      ),
    );
  }
}