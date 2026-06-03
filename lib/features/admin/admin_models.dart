import 'package:flutter/material.dart';

enum AdminArtisanStatus { pendingSetup, active, suspended }

enum AdminOrderStatus { pending, confirmed, shipped, delivered, cancelled }

class AdminArtisan {
  const AdminArtisan({
    required this.name,
    required this.role,
    required this.location,
    required this.status,
    required this.products,
    required this.followers,
  });

  final String name;
  final String role;
  final String location;
  final AdminArtisanStatus status;
  final int products;
  final int followers;

  AdminArtisan copyWith({AdminArtisanStatus? status}) {
    return AdminArtisan(
      name: name,
      role: role,
      location: location,
      status: status ?? this.status,
      products: products,
      followers: followers,
    );
  }
}

class AdminProduct {
  const AdminProduct({
    required this.name,
    required this.artisan,
    required this.category,
    required this.price,
    required this.stock,
    required this.isFeatured,
  });

  final String name;
  final String artisan;
  final String category;
  final double price;
  final int stock;
  final bool isFeatured;
}

class AdminOrder {
  const AdminOrder({
    required this.id,
    required this.customer,
    required this.total,
    required this.status,
    required this.items,
    required this.date,
  });

  final String id;
  final String customer;
  final double total;
  final AdminOrderStatus status;
  final int items;
  final DateTime date;

  AdminOrder copyWith({AdminOrderStatus? status}) {
    return AdminOrder(
      id: id,
      customer: customer,
      total: total,
      status: status ?? this.status,
      items: items,
      date: date,
    );
  }
}

class AdminOverview {
  const AdminOverview({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalArtisans,
    required this.totalCustomers,
  });

  final double totalRevenue;
  final int totalOrders;
  final int totalArtisans;
  final int totalCustomers;
}

const adminOverview = AdminOverview(
  totalRevenue: 18640.75,
  totalOrders: 248,
  totalArtisans: 42,
  totalCustomers: 1118,
);

final adminArtisans = <AdminArtisan>[
  const AdminArtisan(
    name: 'Chantha Silk Co-op',
    role: 'Silk Weaver',
    location: 'Takeo Province',
    status: AdminArtisanStatus.active,
    products: 14,
    followers: 184,
  ),
  const AdminArtisan(
    name: 'Sarath Silverworks',
    role: 'Silversmith',
    location: 'Phnom Penh',
    status: AdminArtisanStatus.pendingSetup,
    products: 9,
    followers: 149,
  ),
  const AdminArtisan(
    name: 'Rith Wood Studio',
    role: 'Wood Carver',
    location: 'Siem Reap',
    status: AdminArtisanStatus.suspended,
    products: 11,
    followers: 97,
  ),
];

final adminProducts = <AdminProduct>[
  const AdminProduct(
    name: 'Khmer Silk Krama',
    artisan: 'Chantha Silk Co-op',
    category: 'Textile',
    price: 28,
    stock: 18,
    isFeatured: true,
  ),
  const AdminProduct(
    name: 'Silver Apsara Plaque',
    artisan: 'Sarath Silverworks',
    category: 'Decor',
    price: 145,
    stock: 6,
    isFeatured: true,
  ),
  const AdminProduct(
    name: 'Kampot Pepper Gift Box',
    artisan: 'Rith Wood Studio',
    category: 'Edible',
    price: 35,
    stock: 29,
    isFeatured: false,
  ),
  const AdminProduct(
    name: 'Carved Jackfruit Elephant',
    artisan: 'Rith Wood Studio',
    category: 'Souvenir',
    price: 22,
    stock: 11,
    isFeatured: false,
  ),
];

final adminOrders = <AdminOrder>[
  AdminOrder(
    id: 'ORD-1042',
    customer: 'Sokha Neang',
    total: 108,
    status: AdminOrderStatus.pending,
    items: 3,
    date: DateTime(2026, 6, 2),
  ),
  AdminOrder(
    id: 'ORD-1041',
    customer: 'Mina Chen',
    total: 254,
    status: AdminOrderStatus.shipped,
    items: 5,
    date: DateTime(2026, 6, 1),
  ),
  AdminOrder(
    id: 'ORD-1040',
    customer: 'Ratan Vuth',
    total: 86,
    status: AdminOrderStatus.confirmed,
    items: 2,
    date: DateTime(2026, 6, 1),
  ),
  AdminOrder(
    id: 'ORD-1039',
    customer: 'Dara Sok',
    total: 312,
    status: AdminOrderStatus.delivered,
    items: 6,
    date: DateTime(2026, 5, 30),
  ),
];

Color statusColor(AdminArtisanStatus status) {
  switch (status) {
    case AdminArtisanStatus.active:
      return const Color(0xFF2E7D32);
    case AdminArtisanStatus.pendingSetup:
      return const Color(0xFFB26A00);
    case AdminArtisanStatus.suspended:
      return const Color(0xFFC0392B);
  }
}

Color orderStatusColor(AdminOrderStatus status) {
  switch (status) {
    case AdminOrderStatus.pending:
      return const Color(0xFF8C6500);
    case AdminOrderStatus.confirmed:
      return const Color(0xFF3B82F6);
    case AdminOrderStatus.shipped:
      return const Color(0xFF0F766E);
    case AdminOrderStatus.delivered:
      return const Color(0xFF2E7D32);
    case AdminOrderStatus.cancelled:
      return const Color(0xFFC0392B);
  }
}

String artisanStatusLabel(AdminArtisanStatus status) {
  switch (status) {
    case AdminArtisanStatus.active:
      return 'Active';
    case AdminArtisanStatus.pendingSetup:
      return 'Pending setup';
    case AdminArtisanStatus.suspended:
      return 'Suspended';
  }
}

String orderStatusLabel(AdminOrderStatus status) {
  switch (status) {
    case AdminOrderStatus.pending:
      return 'Pending';
    case AdminOrderStatus.confirmed:
      return 'Confirmed';
    case AdminOrderStatus.shipped:
      return 'Shipped';
    case AdminOrderStatus.delivered:
      return 'Delivered';
    case AdminOrderStatus.cancelled:
      return 'Cancelled';
  }
}