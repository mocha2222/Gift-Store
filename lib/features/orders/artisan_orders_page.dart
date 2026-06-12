import 'package:flutter/material.dart';
import 'widgets/order_model.dart';
import 'widgets/order_card.dart';
import 'widgets/order_status_badge.dart';

class ArtisanOrdersPage extends StatefulWidget {
  const ArtisanOrdersPage({super.key});

  @override
  State<ArtisanOrdersPage> createState() => _ArtisanOrdersPageState();
}

class _ArtisanOrdersPageState extends State<ArtisanOrdersPage> {
  late List<OrderModel> _orders;
  OrderStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    _orders = List.from(demoOrders);
  }

  List<OrderModel> get _filtered => _filterStatus == null
      ? _orders
      : _orders.where((o) => o.status == _filterStatus).toList();

  void _updateStatus(String orderId, OrderStatus newStatus) {
    setState(() {
      final idx = _orders.indexWhere((o) => o.id == orderId);
      if (idx != -1) {
        _orders[idx] = OrderModel(
          id:            _orders[idx].id,
          customerName:  _orders[idx].customerName,
          customerEmail: _orders[idx].customerEmail,
          productTitle:  _orders[idx].productTitle,
          productImage:  _orders[idx].productImage,
          price:         _orders[idx].price,
          quantity:      _orders[idx].quantity,
          status:        newStatus,
          createdAt:     _orders[idx].createdAt,
          address:       _orders[idx].address,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF6EE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFF231408)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Customer Orders',
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: Color(0xFF231408),
            )),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(children: [
              _SummaryChip(
                label: 'All',
                count: _orders.length,
                selected: _filterStatus == null,
                onTap: () =>
                    setState(() => _filterStatus = null),
              ),
              const SizedBox(width: 8),
              _SummaryChip(
                label: 'Pending',
                count: _orders
                    .where((o) => o.status == OrderStatus.pending)
                    .length,
                selected: _filterStatus == OrderStatus.pending,
                onTap: () => setState(
                    () => _filterStatus = OrderStatus.pending),
                color: const Color(0xFFF39C12),
              ),
              const SizedBox(width: 8),
              _SummaryChip(
                label: 'Shipped',
                count: _orders
                    .where((o) => o.status == OrderStatus.shipped)
                    .length,
                selected: _filterStatus == OrderStatus.shipped,
                onTap: () => setState(
                    () => _filterStatus = OrderStatus.shipped),
                color: const Color(0xFF8E44AD),
              ),
              const SizedBox(width: 8),
              _SummaryChip(
                label: 'Done',
                count: _orders
                    .where((o) => o.status == OrderStatus.delivered)
                    .length,
                selected: _filterStatus == OrderStatus.delivered,
                onTap: () => setState(
                    () => _filterStatus = OrderStatus.delivered),
                color: const Color(0xFF1AA363),
              ),
            ]),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('📦',
                            style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text(
                          _filterStatus == null
                              ? 'No orders yet'
                              : 'No ${_filterStatus!.name} orders',
                          style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700,
                            color: Color(0xFF231408),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, i) {
                      final order = _filtered[i];
                      return OrderCard(
                        order: order,
                        onUpdateStatus: (s) =>
                            _updateStatus(order.id, s),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
    this.color = const Color(0xFFB8770D),
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : const Color(0xFFEAD5A8),
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF5E4A35),
          ),
        ),
      ),
    );
  }
}