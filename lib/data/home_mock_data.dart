import 'package:flutter/material.dart';

class DisciplineItem {
  final IconData icon;
  final String label;
  const DisciplineItem({required this.icon, required this.label});
}

const disciplines = [
  DisciplineItem(icon: Icons.waves_rounded, label: 'Silk'),
  DisciplineItem(icon: Icons.diamond_outlined, label: 'Silver'),
  DisciplineItem(icon: Icons.park_outlined, label: 'Wood'),
  DisciplineItem(icon: Icons.spa_outlined, label: 'Edible'),
  DisciplineItem(icon: Icons.auto_awesome_outlined, label: 'Jewelry'),
];

class GiftItem {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String imageUrl;
  final Color accent;
  final String? dimensions;
  final List<ProductReview> reviews;
  final String story;
  final String culturalBackground;
  final String materialInfo;
  final int stock;
  final int discount;

  const GiftItem({
    this.id = '',
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.accent,
    this.dimensions,
    this.reviews = const [],
    this.story = '',
    this.culturalBackground = '',
    this.materialInfo = '',
    this.stock = 10,
    this.discount = 0,
  });

  factory GiftItem.fromJson(Map<String, dynamic> json) {
    const accents = [
      Color(0xFF6B4C9A),
      Color(0xFF5B7FA6),
      Color(0xFF4A7C59),
      Color(0xFF7A5230),
      Color(0xFFC0392B),
    ];
    final colorHashCode = (json['_id']?.hashCode ?? 0).abs();
    
    return GiftItem(
      id: json['_id']?.toString() ?? '',
      title: json['name']?.toString() ?? 'Unnamed Product',
      subtitle: json['description']?.toString() ?? '',
      price: '\$${json['price']?.toString() ?? '0.00'}',
      imageUrl: json['image']?.toString() ?? '',
      accent: accents[colorHashCode % accents.length],
      dimensions: json['dimensions']?.toString(),
      story: json['story']?.toString() ?? '',
      culturalBackground: json['cultural_background']?.toString() ?? '',
      materialInfo: json['material_info']?.toString() ?? '',
      stock: json['stock'] is int ? json['stock'] : int.tryParse(json['stock']?.toString() ?? '0') ?? 0,
      discount: json['discount'] is int ? json['discount'] : int.tryParse(json['discount']?.toString() ?? '0') ?? 0,
    );
  }
}

class ProductReview {
  final String name;
  final String location;
  final double rating;
  final String comment;
  final String avatarUrl;

  const ProductReview({
    required this.name,
    required this.location,
    required this.rating,
    required this.comment,
    required this.avatarUrl,
  });
}

const trendingGifts = [
  GiftItem(
    title: 'Khmer Silk Krama',
    subtitle: 'Hand-woven in Takeo Province using natural indigo dye.',
    price:    '\$28.00',
    imageUrl: 'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=600&q=80',
    accent:   Color(0xFF6B4C9A),
    dimensions: '180cm x 55cm',
    reviews: [
      ProductReview(
        name: 'Serey Roth',
        location: 'Takeo Province, Master Weaver',
        rating: 5.0,
        comment: 'Beautiful weave and the color is exactly as shown. It feels premium and authentic.',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&q=80',
      ),
      ProductReview(
        name: 'Nina',
        location: 'Phnom Penh',
        rating: 4.8,
        comment: 'Soft, lightweight, and perfect as a gift. Packaging was excellent too.',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
      ),
    ],
  ),
  GiftItem(
    title: 'Silver Apsara Plaque',
    subtitle: 'Hand-chased sterling silver — a symbol of Khmer heritage.',
    price:    '\$145.00',
    imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=600&q=80',
    accent:   Color(0xFF5B7FA6),
    dimensions: '24cm x 18cm',
    reviews: [
      ProductReview(
        name: 'Vannak',
        location: 'Phnom Penh',
        rating: 5.0,
        comment: 'The craftsmanship is exceptional. It looks even better in person.',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
      ),
    ],
  ),
  GiftItem(
    title: 'Kampot Pepper Gift Box',
    subtitle: 'GI-certified black, red & white pepper from Kampot.',
    price:    '\$35.00',
    imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&q=80',
    accent:   Color(0xFF4A7C59),
    dimensions: 'Box: 20cm x 14cm x 6cm',
    reviews: [
      ProductReview(
        name: 'Dara',
        location: 'Siem Reap',
        rating: 4.9,
        comment: 'Fresh aroma and a great presentation box for gifting.',
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200&q=80',
      ),
    ],
  ),
  GiftItem(
    title: 'Carved Jackfruit Elephant',
    subtitle: 'Sustainably carved from jackfruit wood, beeswax finish.',
    price:    '\$22.00',
    imageUrl: 'https://images.unsplash.com/photo-1567361808960-dec9cb578182?w=600&q=80',
    accent:   Color(0xFF7A5230),
    dimensions: '15cm x 10cm x 8cm',
    reviews: [
      ProductReview(
        name: 'Malis',
        location: 'Battambang',
        rating: 5.0,
        comment: 'A beautiful decorative piece and the carving is very detailed.',
        avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&q=80',
      ),
    ],
  ),
];

class PromoItem {
  final String title;
  final String code;
  final String description;
  final int discountPercent;
  final Color color;
  const PromoItem({
    required this.title,
    required this.code,
    required this.description,
    required this.discountPercent,
    required this.color,
  });
}

const promotions = [
  PromoItem(
    title: 'Khmer New Year 🎉',
    code: 'BONN20',
    description: '20% off all Textile & Edible items',
    discountPercent: 20,
    color: Color(0xFFC0392B),
  ),
  PromoItem(
    title: 'Wedding Special 💍',
    code: 'WEDDING10',
    description: '10% off all Wedding Collection items',
    discountPercent: 10,
    color: Color(0xFF8C6500),
  ),
  PromoItem(
    title: 'First Order 🎁',
    code: 'FIRSTGIFT25',
    description: '25% off your very first order',
    discountPercent: 25,
    color: Color(0xFF4A7C59),
  ),
];

class CollectionItem {
  final String name;
  final String occasion;
  final String itemCount;
  final String imageUrl;
  const CollectionItem({
    required this.name,
    required this.occasion,
    required this.itemCount,
    required this.imageUrl,
  });
}

const collections = [
  CollectionItem(
    name: 'For Her',
    occasion: 'Any Occasion',
    itemCount: '11 items',
    imageUrl:
        'https://images.unsplash.com/photo-1611085583191-a3b181a88401?w=400&q=80',
  ),
  CollectionItem(
    name: 'For Him',
    occasion: 'Any Occasion',
    itemCount: '7 items',
    imageUrl:
        'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400&q=80',
  ),
  CollectionItem(
    name: 'Wedding',
    occasion: 'Wedding Gift',
    itemCount: '12 items',
    imageUrl:
        'https://images.unsplash.com/photo-1606800052052-a08af7148866?w=400&q=80',
  ),
  CollectionItem(
    name: 'Tourist',
    occasion: 'Souvenir',
    itemCount: '13 items',
    imageUrl:
        'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=400&q=80',
  ),
];

class ArtisanProduct {
  final String title;
  final String price;
  final String imagePath;

  const ArtisanProduct({
    required this.title,
    required this.price,
    required this.imagePath,
  });

  Map<String, String> toJson() => {
    'title': title,
    'price': price,
    'imagePath': imagePath,
  };

  factory ArtisanProduct.fromJson(Map<String, dynamic> json) {
    return ArtisanProduct(
      title: json['title']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? '',
    );
  }
}

class MakerItem {
  final String name;
  final String role;
  final String quote;
  final String avatarUrl;
  final int followerCount;
  final List<ArtisanProduct> products;
  const MakerItem({
    required this.name,
    required this.role,
    required this.quote,
    required this.avatarUrl,
    required this.followerCount,
    required this.products,
  });
}

const makers = [
  MakerItem(
    name: 'Chantha Silk Co-op',
    role: 'Silk Weaver · Takeo Province',
    quote: 'Every thread carries the memory of our grandmothers.',
    avatarUrl: 'assets/images/artisans/chantha.jpg',
    followerCount: 184,
    products: [
      ArtisanProduct(
        title: 'Krama',
        price: '\$28.00',
        imagePath: 'assets/images/products/Krama.jpg',
      ),
      ArtisanProduct(
        title: 'Silk Wallet',
        price: '\$34.00',
        imagePath: 'assets/images/products/Silk-wallet.jpg',
      ),
      ArtisanProduct(
        title: 'Table Runner',
        price: '\$42.00',
        imagePath: 'assets/images/products/table-runner.jpg',
      ),
      ArtisanProduct(
        title: 'Gift Set',
        price: '\$48.00',
        imagePath: 'assets/images/products/gift-set.jpg',
      ),
    ],
  ),
  MakerItem(
    name: 'Sarath Silverworks',
    role: 'Silversmith · Phnom Penh',
    quote: 'I learned to chase silver from my father. Each piece takes days.',
    avatarUrl: 'assets/images/artisans/sarath.jpg',
    followerCount: 149,
    products: [
      ArtisanProduct(
        title: 'Silver Bracelet',
        price: '\$22.00',
        imagePath: 'assets/images/products/silver-bracelet.jpg',
      ),
      ArtisanProduct(
        title: 'Silver Box',
        price: '\$16.00',
        imagePath: 'assets/images/products/silver-box.jpg',
      ),
      ArtisanProduct(
        title: 'Silver Tray',
        price: '\$24.00',
        imagePath: 'assets/images/products/silver-tray.jpg',
      ),
      ArtisanProduct(
        title: 'Silver Earrings',
        price: '\$19.00',
        imagePath: 'assets/images/products/silver-earrings.jpg',
      ),
    ],
  ),
  MakerItem(
    name: 'Rith Wood Studio',
    role: 'Wood Carver · Siem Reap',
    quote: 'The forest gives us the wood. We give back art.',
    avatarUrl: 'assets/images/artisans/rith.jpg',
    followerCount: 97,
    products: [
      ArtisanProduct(
        title: 'Absara Statue',
        price: '\$31.00',
        imagePath: 'assets/images/products/absara.jpg',
      ),
      ArtisanProduct(
        title: 'Wooden Clock',
        price: '\$24.00',
        imagePath: 'assets/images/products/wooden-clock.jpg',
      ),
      ArtisanProduct(
        title: 'Wooden Bowl',
        price: '\$29.00',
        imagePath: 'assets/images/products/wooden-bowl.jpg',
      ),
      ArtisanProduct(
        title: 'Wooden Bed',
        price: '\$36.00',
        imagePath: 'assets/images/products/wooden-bed.jpg',
      ),
    ],
  ),
];

// Collection specific mock items
final forHerGifts = [
  trendingGifts[0], // Khmer Silk Krama
  const GiftItem(
    title: 'Silver Lotus Earrings',
    subtitle: 'Sterling silver studs styled after Cambodia\'s sacred lotus.',
    price: '\$45.00',
    imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=600&q=80',
    accent: Color(0xFF5B7FA6),
    dimensions: '1.2cm diameter',
  ),
  const GiftItem(
    title: 'Golden Silk Scarf',
    subtitle: 'Shimmering natural golden silk woven by hand in Siem Reap.',
    price: '\$55.00',
    imageUrl: 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=600&q=80',
    accent: Color(0xFF8C6500),
    dimensions: '170cm x 45cm',
  ),
  const GiftItem(
    title: 'Jasmine Blossom Essential Oil',
    subtitle: 'Pure steam-distilled local jasmine essential oil for wellness.',
    price: '\$18.00',
    imageUrl: 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108?w=600&q=80',
    accent: Color(0xFF4A7C59),
    dimensions: '15ml bottle',
  ),
  const GiftItem(
    title: 'Handcrafted Bead Bracelet',
    subtitle: 'Brightly colored ceramic beads strung together by local artisans.',
    price: '\$12.00',
    imageUrl: 'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=600&q=80',
    accent: Color(0xFF6B4C9A),
    dimensions: 'Elastic (fits all)',
  ),
  const GiftItem(
    title: 'Lotus Flower Clay Incense Burner',
    subtitle: 'Traditional clay burner shaped like a lotus blossom.',
    price: '\$16.00',
    imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600&q=80',
    accent: Color(0xFF7A5230),
    dimensions: '10cm x 10cm x 5cm',
  ),
];

final forHimGifts = [
  trendingGifts[2], // Kampot Pepper Gift Box
  trendingGifts[3], // Carved Jackfruit Elephant
  const GiftItem(
    title: 'Premium Wood Card Holder',
    subtitle: 'Sleek double-sided card holder carved from reclaimed rosewood.',
    price: '\$25.00',
    imageUrl: 'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?w=600&q=80',
    accent: Color(0xFF7A5230),
    dimensions: '10cm x 6.5cm',
  ),
  const GiftItem(
    title: 'Wild Forest Honey',
    subtitle: '100% organic raw honey harvested from the forests of Mondulkiri.',
    price: '\$29.00',
    imageUrl: 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=600&q=80',
    accent: Color(0xFF8C6500),
    dimensions: '350g jar',
  ),
  const GiftItem(
    title: 'Hand-woven Bamboo Hat',
    subtitle: 'Traditional sun hat woven with natural split bamboo fibers.',
    price: '\$15.00',
    imageUrl: 'https://images.unsplash.com/photo-1533468432434-200dec3bde92?w=600&q=80',
    accent: Color(0xFF4A7C59),
    dimensions: '40cm diameter',
  ),
  const GiftItem(
    title: 'Engraved Coconut Shell Bowl',
    subtitle: 'Polished coconut shell bowl with hand-etched geometric patterns.',
    price: '\$10.00',
    imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&q=80',
    accent: Color(0xFF7A5230),
    dimensions: '12cm diameter',
  ),
];

final weddingGifts = [
  trendingGifts[1], // Silver Apsara Plaque
  trendingGifts[0], // Khmer Silk Krama
  const GiftItem(
    title: 'Golden Silk Bed Runner',
    subtitle: 'Intricate golden silk brocade perfect for modern or traditional bedrooms.',
    price: '\$120.00',
    imageUrl: 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=600&q=80',
    accent: Color(0xFF8C6500),
    dimensions: '220cm x 50cm',
  ),
  const GiftItem(
    title: 'Betel Silver Box',
    subtitle: 'Hand-shaped silver-plated copper box used traditionally for greetings.',
    price: '\$85.00',
    imageUrl: 'https://images.unsplash.com/photo-1618220179428-22790b461013?w=600&q=80',
    accent: Color(0xFF5B7FA6),
    dimensions: '12cm x 12cm x 10cm',
  ),
  const GiftItem(
    title: 'Ceramic Tea Set',
    subtitle: 'Hand-thrown clay teapot with four matching cups in a celadon glaze.',
    price: '\$75.00',
    imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=600&q=80',
    accent: Color(0xFF7A5230),
    dimensions: 'Teapot: 600ml, Cups: 120ml',
  ),
];

final touristGifts = [
  trendingGifts[3], // Carved Jackfruit Elephant
  trendingGifts[2], // Kampot Pepper Gift Box
  trendingGifts[0], // Khmer Silk Krama
  const GiftItem(
    title: 'Angkor Wat Sandstone Relief',
    subtitle: 'Sandstone relief plaque replica featuring carvings of Angkor Wat.',
    price: '\$18.00',
    imageUrl: 'https://images.unsplash.com/photo-1608958415710-cb83713028d7?w=600&q=80',
    accent: Color(0xFF7A5230),
    dimensions: '15cm x 10cm',
  ),
  const GiftItem(
    title: 'Siem Reap Clay Mug',
    subtitle: 'Stoneware mug hand-pressed with banana leaf textures.',
    price: '\$14.00',
    imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=600&q=80',
    accent: Color(0xFF8C6500),
    dimensions: '350ml',
  ),
];

List<GiftItem> getGiftsForCollection(String collectionName) {
  switch (collectionName) {
    case 'For Her':
      return forHerGifts;
    case 'For Him':
      return forHimGifts;
    case 'Wedding':
      return weddingGifts;
    case 'Tourist':
      return touristGifts;
    default:
      return trendingGifts;
  }
}

