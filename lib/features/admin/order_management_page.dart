import 'package:flutter/material.dart';

import 'admin_models.dart';
import 'widgets/order_widgets.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  late final List<AdminOrder> _orders = List.of(adminOrders);
  AdminOrderStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == null ? _orders : _orders.where((order) => order.status == _filter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OrderToolbar(
            title: 'Order Management',
            subtitle: 'Filter orders by status, inspect details, and update order progress.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: const Text('All orders'),
                selected: _filter == null,
                onSelected: (_) => setState(() => _filter = null),
              ),
              ...AdminOrderStatus.values.map(
                (status) => ChoiceChip(
                  label: Text(orderStatusLabel(status)),
                  selected: _filter == status,
                  onSelected: (_) => setState(() => _filter = status),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...filtered.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: OrderCard(
                order: order,
                onDetails: () => _showDetails(order),
                onStatusChanged: (status) => setState(() {
                  final index = _orders.indexOf(order);
                  _orders[index] = order.copyWith(status: status);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(AdminOrder order) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(order.id),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.customer}'),
            Text('Total: \$${order.total.toStringAsFixed(2)}'),
            Text('Items: ${order.items}'),
            Text('Date: ${order.date.toIso8601String().split('T').first}'),
            Text('Status: ${orderStatusLabel(order.status)}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close'))],
      ),
    );
  }
}
