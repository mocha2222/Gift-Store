import 'package:flutter/material.dart';

class ArtisanDashboardStatCardData {
  const ArtisanDashboardStatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.cardColor,
    required this.trendText,
    required this.trendUp,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color cardColor;
  final String trendText;
  final bool trendUp;
}

const artisanDashboardStatCards = <ArtisanDashboardStatCardData>[
  ArtisanDashboardStatCardData(
    label: 'Total Orders',
    value: '128',
    icon: Icons.shopping_bag_outlined,
    cardColor: Color(0xFFF5D8B0),
    trendText: '18 pending today',
    trendUp: true,
  ),
  ArtisanDashboardStatCardData(
    label: 'Revenue',
    value: '\$4,320',
    icon: Icons.attach_money,
    cardColor: Color(0xFFE5D8F6),
    trendText: 'This week +12%',
    trendUp: true,
  ),
  ArtisanDashboardStatCardData(
    label: 'Total Products',
    value: '34',
    icon: Icons.inventory_2_outlined,
    cardColor: Color(0xFFD7F0E9),
    trendText: '4 low stock items',
    trendUp: false,
  ),
  ArtisanDashboardStatCardData(
    label: 'Avg Rating',
    value: '4.8',
    icon: Icons.star_outline,
    cardColor: Color(0xFFF7E2B9),
    trendText: '96% positive feedback',
    trendUp: true,
  ),
];

class ArtisanDashboardOrderData {
  const ArtisanDashboardOrderData({
    required this.customerName,
    required this.productName,
    required this.amount,
    required this.status,
  });

  final String customerName;
  final String productName;
  final String amount;
  final String status;
}

const artisanDashboardOrders = <ArtisanDashboardOrderData>[
  ArtisanDashboardOrderData(
    customerName: 'Sothea Meas',
    productName: 'Hand-woven basket',
    amount: '\$28.00',
    status: 'Pending',
  ),
  ArtisanDashboardOrderData(
    customerName: 'Lin Wei',
    productName: 'Ceramic tea set',
    amount: '\$65.00',
    status: 'Completed',
  ),
  ArtisanDashboardOrderData(
    customerName: 'Dara Pich',
    productName: 'Silk scarf — indigo',
    amount: '\$42.00',
    status: 'Shipped',
  ),
  ArtisanDashboardOrderData(
    customerName: 'Amara Sok',
    productName: 'Rattan wall decor',
    amount: '\$55.00',
    status: 'Processing',
  ),
];

class ArtisanDashboardChipData {
  const ArtisanDashboardChipData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const artisanDashboardHeroChips = <ArtisanDashboardChipData>[
  ArtisanDashboardChipData(
    label: '18 new orders',
    icon: Icons.shopping_bag_outlined,
  ),
  ArtisanDashboardChipData(
    label: '3 unread chats',
    icon: Icons.chat_bubble_outline,
  ),
  ArtisanDashboardChipData(
    label: '2 alerts',
    icon: Icons.notifications_outlined,
  ),
];

class ArtisanDashboardQuickActionData {
  const ArtisanDashboardQuickActionData({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

const artisanDashboardQuickActions = <ArtisanDashboardQuickActionData>[
  ArtisanDashboardQuickActionData(
    icon: Icons.add_box_outlined,
    label: 'Add Product',
  ),
  ArtisanDashboardQuickActionData(
    icon: Icons.bar_chart_outlined,
    label: 'View Revenue',
  ),
  ArtisanDashboardQuickActionData(
    icon: Icons.local_offer_outlined,
    label: 'Promotions',
  ),
  ArtisanDashboardQuickActionData(
    icon: Icons.chat_bubble_outlined,
    label: 'Messages',
  ),
];

const artisanDashboardUnreadMessageText = 'You have 3 unread messages';
