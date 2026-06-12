import 'package:flutter/material.dart';
import 'order_model.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatus status;

  static const _config = {
    OrderStatus.pending: (
      label: 'Pending',
      color: Color(0xFFF39C12),
      bg: Color(0xFFFEF9EC),
    ),
    OrderStatus.processing: (
      label: 'Processing',
      color: Color(0xFF2980B9),
      bg: Color(0xFFEBF5FB),
    ),
    OrderStatus.shipped: (
      label: 'Shipped',
      color: Color(0xFF8E44AD),
      bg: Color(0xFFF5EEF8),
    ),
    OrderStatus.delivered: (
      label: 'Delivered',
      color: Color(0xFF1AA363),
      bg: Color(0xFFEAF7F1),
    ),
    OrderStatus.cancelled: (
      label: 'Cancelled',
      color: Color(0xFFC0392B),
      bg: Color(0xFFFFEBEB),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final cfg = _config[status]!;
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cfg.bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cfg.color.withValues(alpha: 0.35)),
      ),
      child: Text(
        '● ${cfg.label}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: cfg.color,
        ),
      ),
    );
  }
}