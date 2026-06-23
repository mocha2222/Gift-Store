import 'package:flutter/material.dart';

enum AdminArtisanStatus { pendingSetup, active, suspended }

enum AdminOrderStatus { pending, confirmed, shipped, delivered, cancelled }

class AdminArtisan {
  const AdminArtisan({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.location,
    required this.status,
    required this.products,
    required this.followers,
    this.profileImage,
  });

  final String id;
  final String userId;
  final String name;
  final String role;
  final String location;
  final AdminArtisanStatus status;
  final int products;
  final int followers;
  final String? profileImage;

  AdminArtisan copyWith({AdminArtisanStatus? status}) {
    return AdminArtisan(
      id: id,
      userId: userId,
      name: name,
      role: role,
      location: location,
      status: status ?? this.status,
      products: products,
      followers: followers,
      profileImage: profileImage,
    );
  }

  factory AdminArtisan.fromJson(Map<String, dynamic> json) {
    AdminArtisanStatus parseStatus(String? s) {
      if (s == 'active') return AdminArtisanStatus.active;
      if (s == 'suspended') return AdminArtisanStatus.suspended;
      return AdminArtisanStatus.pendingSetup;
    }
    // Extract profile image from populated user_id or artisan cover_image
    final userMapOrStr = json['user_id'];
    String? profileImg;
    String userIdStr = '';
    
    if (userMapOrStr is Map) {
      userIdStr = userMapOrStr['_id']?.toString() ?? userMapOrStr['id']?.toString() ?? '';
      if (userMapOrStr['profile_image'] != null && userMapOrStr['profile_image'].toString().isNotEmpty) {
        profileImg = userMapOrStr['profile_image'].toString();
      }
    } else if (userMapOrStr != null) {
      userIdStr = userMapOrStr.toString();
    }
    
    if (profileImg == null && json['cover_image'] != null && json['cover_image'].toString().isNotEmpty) {
      profileImg = json['cover_image'].toString();
    }
    
    return AdminArtisan(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      userId: userIdStr,
      name: json['shop_name'] ?? (userMapOrStr is Map ? userMapOrStr['name'] ?? 'Unknown' : 'Unknown'),
      role: json['craft_type'] ?? 'Artisan',
      location: json['region'] ?? 'Unknown',
      status: parseStatus(json['status']),
      products: json['products_count'] ?? 0,
      followers: 0,
      profileImage: profileImg,
    );
  }
}

class AdminProduct {
  const AdminProduct({
    required this.id,
    required this.name,
    required this.artisan,
    required this.category,
    required this.price,
    required this.stock,
    required this.isFeatured,
  });

  final String id;
  final String name;
  final String artisan;
  final String category;
  final double price;
  final int stock;
  final bool isFeatured;

  factory AdminProduct.fromJson(Map<String, dynamic> json) {
    final artisan = json['artisan_id'];
    final artisanName = (artisan is Map && artisan.containsKey('shop_name')) ? artisan['shop_name'] : 'Unknown';
    final category = json['category_id'];
    final categoryName = (category is Map && category.containsKey('category_name')) ? category['category_name'] : 'Other';

    double basePrice = (json['price'] ?? 0).toDouble();
    int discount = json['discount'] is int ? json['discount'] : int.tryParse(json['discount']?.toString() ?? '0') ?? 0;
    double finalPrice = discount > 0 ? basePrice * (1 - discount / 100) : basePrice;

    return AdminProduct(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      artisan: artisanName,
      category: categoryName,
      price: finalPrice,
      stock: json['stock'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
    );
  }
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

  factory AdminOrder.fromJson(Map<String, dynamic> json) {
    AdminOrderStatus parseStatus(String? s) {
      switch (s) {
        case 'confirmed': return AdminOrderStatus.confirmed;
        case 'shipped': return AdminOrderStatus.shipped;
        case 'delivered': return AdminOrderStatus.delivered;
        case 'cancelled': return AdminOrderStatus.cancelled;
        default: return AdminOrderStatus.pending;
      }
    }
    
    final user = json['user_id'];
    final userName = (user is Map && user.containsKey('name')) ? user['name'] : 'Unknown';
    final itemsList = json['items'] as List<dynamic>? ?? [];

    return AdminOrder(
      id: (json['_id'] ?? json['id'])?.toString().substring(0, 8) ?? 'ORD-???',
      customer: userName,
      total: (json['total_price'] ?? 0).toDouble(),
      status: parseStatus(json['status']),
      items: itemsList.length,
      date: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
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

List<AdminArtisan> adminArtisans = [];
List<AdminProduct> adminProducts = [];
List<AdminOrder> adminOrders = [];
AdminOverview adminOverview = const AdminOverview(
  totalRevenue: 0,
  totalOrders: 0,
  totalArtisans: 0,
  totalCustomers: 0,
);

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