import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../admin_models.dart';

class OrderToolbar extends StatelessWidget {
  const OrderToolbar({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.cormorantGaramond(fontSize: 26, fontWeight: FontWeight.w700, color: const Color(0xFF231408))),
          const SizedBox(height: 6),
          Text(subtitle, style: GoogleFonts.inter(height: 1.5, color: const Color(0xFF6B5D4F))),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, required this.onDetails, required this.onStatusChanged});

  final AdminOrder order;
  final VoidCallback onDetails;
  final ValueChanged<AdminOrderStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final color = orderStatusColor(order.status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2D3BE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
                child: Icon(Icons.receipt_long_rounded, color: color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      order.id,
                      style: GoogleFonts.cormorantGaramond(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF231408)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.customer} · ${order.items} items · ${order.date.toIso8601String().split('T').first}',
                      style: GoogleFonts.inter(color: const Color(0xFF6B5D4F)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                textAlign: TextAlign.right,
                style: GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w700, fontSize: 18, color: const Color(0xFF231408))
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 120,
                child: DropdownButton<AdminOrderStatus>(
                  isExpanded: true,
                  value: order.status,
                  underline: const SizedBox.shrink(),
                  items: AdminOrderStatus.values
                      .map((status) => DropdownMenuItem(value: status, child: Text(orderStatusLabel(status), overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: (status) {
                    if (status != null) onStatusChanged(status);
                  },
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onDetails,
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                label: const Text('Details')
              ),
            ],
          ),
        ],
      ),
    );
  }
}
