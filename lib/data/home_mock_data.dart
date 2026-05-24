import 'package:flutter/material.dart';

class DisciplineItem {
  const DisciplineItem({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

class GiftItem {
  const GiftItem({
    required this.title,
    required this.price,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String price;
  final Color accent;
  final IconData icon;
}

class MakerItem {
  const MakerItem({
    required this.name,
    required this.role,
    required this.quote,
  });

  final String name;
  final String role;
  final String quote;
}

const disciplines = <DisciplineItem>[
  DisciplineItem(label: 'Textile', icon: Icons.grid_on_rounded),
  DisciplineItem(label: 'Silver', icon: Icons.diamond_outlined),
  DisciplineItem(label: 'Wood', icon: Icons.park_outlined),
];

const trendingGifts = <GiftItem>[
  GiftItem(
    title: 'Angkorian Silver Casket',
    price: r'$245.00',
    accent: Color(0xFF44261B),
    icon: Icons.diamond_rounded,
  ),
  GiftItem(
    title: 'Golden Mulberry Silk',
    price: r'$180.00',
    accent: Color(0xFFD6B07B),
    icon: Icons.auto_awesome_rounded,
  ),
  GiftItem(
    title: 'Celadon Earth Vases',
    price: r'$115.00',
    accent: Color(0xFF203335),
    icon: Icons.water_drop_outlined,
  ),
];

const makers = <MakerItem>[
  MakerItem(
    name: 'Master Samnang',
    role: 'Woodcarver',
    quote: 'I translate the songs of the forest into the grain of the teak wood.',
  ),
];
