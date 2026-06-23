enum OrderStatus { pending, processing, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String customerName;
  final String customerEmail;
  final String productTitle;
  final String productImage;
  final String price;
  final int quantity;
  final OrderStatus status;
  final DateTime createdAt;
  final String address;

  const OrderModel({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.productTitle,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.address,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Parse status string to enum
    OrderStatus parseStatus(String? s) {
      switch (s?.toLowerCase()) {
        case 'confirmed':
        case 'processing':
          return OrderStatus.processing;
        case 'shipped':
          return OrderStatus.shipped;
        case 'delivered':
          return OrderStatus.delivered;
        case 'cancelled':
          return OrderStatus.cancelled;
        default:
          return OrderStatus.pending;
      }
    }

    // Extract customer info from populated user_id
    final user = json['user_id'];
    final customerName = (user is Map) ? (user['name']?.toString() ?? 'Customer') : 'Customer';
    final customerEmail = (user is Map) ? (user['email']?.toString() ?? '') : '';

    // Extract product info from items
    final items = json['items'] as List<dynamic>? ?? [];
    String productTitle = 'Handcrafted Gift';
    String productImage = '';
    int totalQuantity = 0;
    if (items.isNotEmpty) {
      final firstItem = items[0];
      final prod = firstItem['product_id'];
      if (prod is Map) {
        productTitle = prod['name']?.toString() ?? 'Handcrafted Gift';
        productImage = prod['image']?.toString() ?? '';
      }
      for (final item in items) {
        totalQuantity += (item['quantity'] as num?)?.toInt() ?? 1;
      }
      if (items.length > 1) {
        productTitle += ' (+${items.length - 1} more)';
      }
    }

    final total = (json['total_price'] as num?)?.toDouble() ?? 0.0;

    return OrderModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      customerName: customerName,
      customerEmail: customerEmail,
      productTitle: productTitle,
      productImage: productImage,
      price: '\$${total.toStringAsFixed(2)}',
      quantity: totalQuantity > 0 ? totalQuantity : 1,
      status: parseStatus(json['status']?.toString()),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      address: json['delivery_address']?.toString() ?? '',
    );
  }
}


final demoOrders = <OrderModel>[];