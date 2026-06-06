class ShopLocation {
  final String id;
  final String name;
  final String category;
  final String address;
  final String city;
  final double lat;
  final double lng;
  final double distanceKm;
  final String openHours;
  final bool isOpen;
  final double rating;
  final int reviewCount;
  final String phone;
  final String imageUrl;

  const ShopLocation({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.city,
    required this.lat,
    required this.lng,
    required this.distanceKm,
    required this.openHours,
    required this.isOpen,
    required this.rating,
    required this.reviewCount,
    required this.phone,
    required this.imageUrl,
  });
}

const shopLocations = [
  ShopLocation(
    id: 's1',
    name: 'Chantha Silk Co-op',
    category: 'Silk',
    address: 'St. 178, Phnom Penh',
    city: 'Phnom Penh',
    lat: 11.5564,
    lng: 104.9282,
    distanceKm: 0.8,
    openHours: '8:00 AM – 6:00 PM',
    isOpen: true,
    rating: 4.9,
    reviewCount: 128,
    phone: '+855 12 345 678',
    imageUrl: 'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=400&q=80',
  ),
  ShopLocation(
    id: 's2',
    name: 'Sarath Silverworks',
    category: 'Silver',
    address: 'Sisowath Quay, Phnom Penh',
    city: 'Phnom Penh',
    lat: 11.5680,
    lng: 104.9310,
    distanceKm: 1.4,
    openHours: '9:00 AM – 7:00 PM',
    isOpen: true,
    rating: 4.8,
    reviewCount: 94,
    phone: '+855 12 456 789',
    imageUrl: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400&q=80',
  ),
  ShopLocation(
    id: 's3',
    name: 'Rith Wood Studio',
    category: 'Wood',
    address: 'Pub Street, Siem Reap',
    city: 'Siem Reap',
    lat: 13.3622,
    lng: 103.8597,
    distanceKm: 2.1,
    openHours: '8:00 AM – 8:00 PM',
    isOpen: true,
    rating: 4.7,
    reviewCount: 76,
    phone: '+855 17 234 567',
    imageUrl: 'https://images.unsplash.com/photo-1567361808960-dec9cb578182?w=400&q=80',
  ),
  ShopLocation(
    id: 's4',
    name: 'Kampot Pepper House',
    category: 'Edible',
    address: 'River Road, Kampot',
    city: 'Kampot',
    lat: 10.6103,
    lng: 104.1810,
    distanceKm: 3.5,
    openHours: '7:00 AM – 5:00 PM',
    isOpen: false,
    rating: 4.9,
    reviewCount: 210,
    phone: '+855 33 123 456',
    imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400&q=80',
  ),
  ShopLocation(
    id: 's5',
    name: 'Angkor Craft Gallery',
    category: 'Jewelry',
    address: 'Charles de Gaulle, Siem Reap',
    city: 'Siem Reap',
    lat: 13.3700,
    lng: 103.8550,
    distanceKm: 4.2,
    openHours: '9:00 AM – 9:00 PM',
    isOpen: true,
    rating: 4.6,
    reviewCount: 58,
    phone: '+855 63 789 012',
    imageUrl: 'https://images.unsplash.com/photo-1611085583191-a3b181a88401?w=400&q=80',
  ),
  ShopLocation(
    id: 's6',
    name: 'Mekong Textile House',
    category: 'Silk',
    address: 'National Museum Area, Phnom Penh',
    city: 'Phnom Penh',
    lat: 11.5650,
    lng: 104.9295,
    distanceKm: 1.9,
    openHours: '8:30 AM – 6:30 PM',
    isOpen: true,
    rating: 4.5,
    reviewCount: 43,
    phone: '+855 23 456 789',
    imageUrl: 'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=400&q=80',
  ),
];