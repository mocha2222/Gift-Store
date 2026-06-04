import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardHeroPanel extends StatelessWidget {
  const DashboardHeroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Overview',
            style: GoogleFonts.cormorantGaramond(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
            'Monitor revenue, orders, artisans, and customers from one control center.',
            style: GoogleFonts.inter(color: Color(0xFFFFEBCF), height: 1.5),
          ),
        ],
      ),
    );
  }
}

class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2D3BE)),
        boxShadow: const [
          BoxShadow(color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: tint.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: tint),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: GoogleFonts.cormorantGaramond(fontSize: 28, fontWeight: FontWeight.w700, color: const Color(0xFF231408))),
              const SizedBox(height: 2),
              Text(label, style: GoogleFonts.inter(color: const Color(0xFF7A6655), fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardActionTile extends StatelessWidget {
  const DashboardActionTile({super.key, required this.title, required this.subtitle, required this.icon});

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7EC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2D3BE)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF1E7D5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF8C6500)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF231408))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12.5, height: 1.4, color: Color(0xFF6B5D4F))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
