import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../admin_models.dart';

class ArtisanToolbar extends StatelessWidget {
  const ArtisanToolbar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    // Render only the action button (right aligned) — removes the surrounding info card
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: Text(actionLabel, style: const TextStyle(color: Colors.white)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: const Color(0xFF9E7E5A), // brown/tan from app palette
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArtisanCard extends StatelessWidget {
  const ArtisanCard({super.key, required this.artisan, required this.onView, required this.onToggle});

  final AdminArtisan artisan;
  final VoidCallback onView;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = statusColor(artisan.status);
    final isSuspended = artisan.status == AdminArtisanStatus.suspended;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2D3BE)),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 16, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(Icons.storefront_rounded, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artisan.name,
                      style: GoogleFonts.cormorantGaramond(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF231408)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${artisan.role} · ${artisan.location}',
                      style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF756657)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ArtisanStatusChip(label: artisanStatusLabel(artisan.status), color: color),
              ),
            ],
          ),
          // Use fixed spacing to avoid forcing flex layout that can overflow
          const SizedBox(height: 12),
          Row(
            children: [
              ArtisanMiniStat(label: 'Products', value: artisan.products.toString()),
              const SizedBox(width: 16),
              ArtisanMiniStat(label: 'Followers', value: artisan.followers.toString()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onView,
                  child: const Text('View profile'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: onToggle,
                  child: Text(isSuspended ? 'Activate' : 'Suspend'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ArtisanStatusChip extends StatelessWidget {
  const ArtisanStatusChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
      // Constrain chip width so it doesn't push the row out of bounds
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 110),
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class ArtisanMiniStat extends StatelessWidget {
  const ArtisanMiniStat({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.cormorantGaramond(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF231408)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8C7B6A))),
      ],
    );
  }
}
