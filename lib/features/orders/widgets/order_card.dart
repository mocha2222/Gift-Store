import 'package:flutter/material.dart';
import 'order_model.dart';
import 'order_status_badge.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onUpdateStatus,
  });

  final OrderModel order;
  final ValueChanged<OrderStatus> onUpdateStatus;

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAD5A8)),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000),
              blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 56, height: 56,
                  child: Image.network(order.productImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFF1E7D5))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.productTitle,
                        style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700,
                          color: Color(0xFF231408),
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Text(
                      '${order.customerName}  ·  Qty ${order.quantity}',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFF9E7E5A)),
                    ),
                    const SizedBox(height: 3),
                    Row(children: [
                      Text(order.price,
                          style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w800,
                            color: Color(0xFF8C6500),
                          )),
                      const Spacer(),
                      Text(_timeAgo(order.createdAt),
                          style: const TextStyle(
                              fontSize: 10, color: Color(0xFF9E7E5A))),
                    ]),
                  ],
                ),
              ),
            ]),
          ),

          const Divider(height: 1, color: Color(0xFFF1E7D5)),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Row(children: [
              OrderStatusBadge(status: order.status),
              const Spacer(),
              if (order.status != OrderStatus.delivered &&
                  order.status != OrderStatus.cancelled)
                GestureDetector(
                  onTap: () => _showStatusPicker(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1E7D5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFEAD5A8)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_outlined,
                            size: 13, color: Color(0xFFB8770D)),
                        SizedBox(width: 4),
                        Text('Update',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFB8770D),
                            )),
                      ],
                    ),
                  ),
                ),
            ]),
          ),
        ],
      ),
    );
  }

  void _showStatusPicker(BuildContext context) {
    final next = {
      OrderStatus.pending:    OrderStatus.processing,
      OrderStatus.processing: OrderStatus.shipped,
      OrderStatus.shipped:    OrderStatus.delivered,
    };
    final available = [
      if (next[order.status] != null) next[order.status]!,
      OrderStatus.cancelled,
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFBF6EE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text('Update Order Status',
                style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: Color(0xFF231408),
                )),
            const SizedBox(height: 16),
            ...available.map((s) => GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onUpdateStatus(s);
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEAD5A8)),
                ),
                child: OrderStatusBadge(status: s),
              ),
            )),
          ],
        ),
      ),
    );
  }
}