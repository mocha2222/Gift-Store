import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArtisanOrderRow extends StatelessWidget {
  const ArtisanOrderRow({
    super.key,
    required this.customerName,
    required this.productName,
    required this.amount,
    required this.status,
  });

  final String customerName;
  final String productName;
  final String amount;
  final String status;

  @override
  Widget build(BuildContext context) {
    final badge = StatusBadgeStyle.forStatus(status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF8C6500).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _initials(customerName),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8C6500),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C261E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  productName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF7A6655),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8C6500),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: badge.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: badge.textColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return 'A';
    }
    if (parts.length == 1) {
      final word = parts.first;
      return word.substring(0, word.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class StatusBadgeStyle {
  const StatusBadgeStyle({
    required this.backgroundColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color textColor;

  static StatusBadgeStyle forStatus(String status) {
    switch (status) {
      case 'Pending':
        return const StatusBadgeStyle(
          backgroundColor: Color(0xFFFAEEDA),
          textColor: Color(0xFF854F0B),
        );
      case 'Processing':
        return const StatusBadgeStyle(
          backgroundColor: Color(0xFFE6F1FB),
          textColor: Color(0xFF185FA5),
        );
      case 'Shipped':
        return const StatusBadgeStyle(
          backgroundColor: Color(0xFFEEEDFE),
          textColor: Color(0xFF534AB7),
        );
      case 'Completed':
        return const StatusBadgeStyle(
          backgroundColor: Color(0xFFEAF3DE),
          textColor: Color(0xFF3B6D11),
        );
      case 'Cancelled':
        return const StatusBadgeStyle(
          backgroundColor: Color(0xFFFCEBEB),
          textColor: Color(0xFFA32D2D),
        );
      default:
        return const StatusBadgeStyle(
          backgroundColor: Color(0xFFFAEEDA),
          textColor: Color(0xFF854F0B),
        );
    }
  }
}
