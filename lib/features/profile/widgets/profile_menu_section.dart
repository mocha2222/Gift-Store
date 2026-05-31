import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenuItem {
  const ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
}

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<ProfileMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 4),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9E7E5A),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7EC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE2D3BE)),
          ),
          child: Column(
            children: [
              for (var index = 0; index < items.length; index++) ...[
                ListTile(
                  onTap: items[index].onTap,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color:
                          (items[index].isDestructive
                                  ? const Color(0xFFC0392B)
                                  : const Color(0xFF8C6500))
                              .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      items[index].icon,
                      size: 18,
                      color: items[index].isDestructive
                          ? const Color(0xFFC0392B)
                          : const Color(0xFF8C6500),
                    ),
                  ),
                  title: Text(
                    items[index].label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: items[index].isDestructive
                          ? const Color(0xFFC0392B)
                          : const Color(0xFF2C261E),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF9E7E5A),
                    size: 20,
                  ),
                ),
                if (index != items.length - 1)
                  const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0xFFE2D3BE),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
