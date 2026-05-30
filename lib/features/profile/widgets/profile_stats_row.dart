import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key, required this.stats, this.onStatTap});

  final List<({String label, String value})> stats;
  final List<VoidCallback?>? onStatTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2D3BE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var index = 0; index < stats.length; index++) ...[
            _StatColumn(
              stat: stats[index],
              onTap: onStatTap != null && index < onStatTap!.length
                  ? onStatTap![index]
                  : null,
            ),
            if (index != stats.length - 1)
              Container(width: 1, height: 36, color: const Color(0xFFE2D3BE)),
          ],
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.stat, this.onTap});

  final ({String label, String value}) stat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  stat.value,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8C6500),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stat.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF9E7E5A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
