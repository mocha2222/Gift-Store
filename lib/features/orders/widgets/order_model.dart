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
}


final demoOrders = [
  OrderModel(
    id: 'ORD-001',
    customerName: 'Sophea Meas',
    customerEmail: 'sophea@email.com',
    productTitle: 'Hand-woven Silk Krama',
    productImage:
        'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=400&q=80',
    price: '\$28.00',
    quantity: 2,
    status: OrderStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    address: 'St. 271, Phnom Penh',
  ),
  OrderModel(
    id: 'ORD-002',
    customerName: 'Dara Keo',
    customerEmail: 'dara@email.com',
    productTitle: 'Silver Apsara Bracelet',
    productImage:
        'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400&q=80',
    price: '\$42.00',
    quantity: 1,
    status: OrderStatus.processing,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    address: 'Siem Reap, Cambodia',
  ),
  OrderModel(
    id: 'ORD-003',
    customerName: 'Malis Chan',
    customerEmail: 'malis@email.com',
    productTitle: 'Kampot Pepper Gift Box',
    productImage:
        'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400&q=80',
    price: '\$35.00',
    quantity: 3,
    status: OrderStatus.delivered,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    address: 'Battambang, Cambodia',
  ),
  OrderModel(
    id: 'ORD-004',
    customerName: 'Rith Pov',
    customerEmail: 'rith@email.com',
    productTitle: 'Carved Jackfruit Elephant',
    productImage:
        'https://images.unsplash.com/photo-1567361808960-dec9cb578182?w=400&q=80',
    price: '\$22.00',
    quantity: 1,
    status: OrderStatus.shipped,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    address: 'Kampot, Cambodia',
  ),
];