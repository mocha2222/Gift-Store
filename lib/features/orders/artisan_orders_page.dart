import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/product_api.dart';
import 'widgets/order_model.dart';
import 'widgets/order_card.dart';
import 'widgets/order_status_badge.dart';

class ArtisanOrdersPage extends StatefulWidget {
  const ArtisanOrdersPage({super.key});

  @override
  State<ArtisanOrdersPage> createState() => _ArtisanOrdersPageState();
}

class _ArtisanOrdersPageState extends State<ArtisanOrdersPage> {
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  OrderStatus? _filterStatus;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      setState(() => _isLoading = true);
      final prefs = await SharedPreferences.getInstance();
      var artisanId = prefs.getString('artisan_id') ?? '';

      if (artisanId.isEmpty) {
        // Try to fetch artisan_id from backend
        final token = prefs.getString('access_token');
        final userId = prefs.getString('user_id');
        if (token != null && userId != null) {
          final uri = Uri.parse('${ProductApi.baseUrl}/artisans/by-user/$userId');
          final res = await http.get(uri, headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
          if (res.statusCode == 200) {
            final body = jsonDecode(res.body);
            artisanId = body['_id']?.toString() ?? body['id']?.toString() ?? '';
            if (artisanId.isNotEmpty) {
              await prefs.setString('artisan_id', artisanId);
            }
          }
        }
      }

      if (artisanId.isEmpty) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final rawOrders = await ProductApi.getArtisanOrders(artisanId);
      final orders = rawOrders.map((json) => OrderModel.fromJson(json)).toList();

      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[ArtisanOrders] Error fetching orders: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading orders: $e')),
        );
      }
    }
  }

  List<OrderModel> get _filtered => _filterStatus == null
      ? _orders
      : _orders.where((o) => o.status == _filterStatus).toList();

  Future<void> _updateStatus(String orderId, OrderStatus newStatus) async {
    // Map frontend enum to backend status string
    String backendStatus;
    switch (newStatus) {
      case OrderStatus.pending:
        backendStatus = 'pending';
        break;
      case OrderStatus.processing:
        backendStatus = 'confirmed';
        break;
      case OrderStatus.shipped:
        backendStatus = 'shipped';
        break;
      case OrderStatus.delivered:
        backendStatus = 'delivered';
        break;
      case OrderStatus.cancelled:
        backendStatus = 'cancelled';
        break;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';
      final uri = Uri.parse('${ProductApi.baseUrl}/orders/$orderId/status');
      final res = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': backendStatus}),
      );

      if (res.statusCode == 200) {
        // Update local state
        setState(() {
          final idx = _orders.indexWhere((o) => o.id == orderId);
          if (idx != -1) {
            _orders[idx] = OrderModel(
              id: _orders[idx].id,
              customerName: _orders[idx].customerName,
              customerEmail: _orders[idx].customerEmail,
              productTitle: _orders[idx].productTitle,
              productImage: _orders[idx].productImage,
              price: _orders[idx].price,
              quantity: _orders[idx].quantity,
              status: newStatus,
              createdAt: _orders[idx].createdAt,
              address: _orders[idx].address,
            );
          }
        });
      } else {
        throw Exception('Failed: ${res.body}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF6EE),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Customer Orders',
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: Color(0xFF231408),
            )),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8C6500)))
          : RefreshIndicator(
              onRefresh: _fetchOrders,
              color: const Color(0xFF8C6500),
              child: Column(
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