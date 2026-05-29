import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/home_mock_data.dart';
import '../auth/login_page.dart';
import '../home/widgets/home_footer_nav.dart';
import '../home/widgets/home_header.dart';
import '../quiz/quiz_page.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.item});

  final GiftItem item;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedImage = 0;
  int _quantity = 1;
  bool _isFavorite = false;

  late final List<String> _gallery;

  @override
  void initState() {
    super.initState();
    _gallery = <String>[
      widget.item.imageUrl,
      'https://images.unsplash.com/photo-1524638067-feba7e8b1d7d?w=700&q=80',
      'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=700&q=80',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = <Color>[
      widget.item.accent,
      const Color(0xFFB8770D),
      const Color(0xFF7A4E2D),
    ];

    return Scaffold(
      drawer: _buildDrawer(context),
      backgroundColor: const Color(0xFFF7F0E4),
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Product Detail',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF231408),
                                ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          color: const Color(0xFF231408),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _isFavorite = !_isFavorite),
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
                          color: _isFavorite
                              ? const Color(0xFFC0392B)
                              : const Color(0xFF231408),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        _gallery[_selectedImage],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: colors[_selectedImage].withOpacity(0.18),
                          child: Icon(
                            Icons.image_outlined,
                            size: 72,
                            color: colors[_selectedImage],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 72,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _gallery.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedImage = index),
                          child: Container(
                            width: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _selectedImage == index
                                    ? const Color(0xFF8C6500)
                                    : const Color(0xFFE3D3BE),
                                width: _selectedImage == index ? 2 : 1,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(_gallery[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _Pill(label: 'Heritage Silk'),
                      _Pill(label: 'In Stock'),
                      _Pill(label: 'Handmade'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.item.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF231408),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        widget.item.price,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFB8770D),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '\$110.00',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown.withOpacity(0.55),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7EC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE3D3BE),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Color(0xFFF5A623),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '4.9 (124)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF7A6655),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SectionTitle(title: 'Description'),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.subtitle,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF4F453A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(title: 'Cultural background / story'),
                  const SizedBox(height: 8),
                  const Text(
                    'Inspired by Khmer weaving traditions, this piece reflects the warm color palette, patient handcraft, and symbolic patterns found in Cambodian artisan communities.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF4F453A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoTile(
                    icon: Icons.inventory_2_outlined,
                    title: 'Material information',
                    value:
                        'Mulberry silk, hand-dyed with natural indigo and plant-based pigments',
                  ),
                  const SizedBox(height: 10),
                  _InfoTile(
                    icon: Icons.store_outlined,
                    title: 'Stock availability',
                    value: 'In stock (5 left)',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF231408),
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.remove,
                        onTap: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        onTap: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to favorites')),
                            );
                          },
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                          ),
                          label: const Text('Add to Favorites'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8C6500),
                            side: const BorderSide(
                              color: Color(0xFFD7C1A0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Added $_quantity item(s) to cart'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text('Add to Cart'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFB8770D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SectionTitle(title: 'Story behind this piece'),
                  const SizedBox(height: 8),
                  const Text(
                    'Every thread reflects long-standing craftsmanship passed down through families in Cambodia, turning a gift into a piece of living culture.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Color(0xFF4F453A),
                    ),
                  ),
                  const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(top: false, child: HomeFooterNav(currentIndex: 0)),
        ],
      ),
    );
  }
}

Widget _buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: const Color(0xFFF7F0E4),
    child: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  height: 112,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Khmer Treasures',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Discover handcrafted gifts and stories',
                        style: TextStyle(
                          color: Color(0xFFFFE8C7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _DrawerItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _DrawerItem(
                  icon: Icons.info_outline_rounded,
                  label: 'About Us',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _DrawerItem(
                  icon: Icons.explore_outlined,
                  label: 'Explore',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _DrawerItem(
                  icon: Icons.grid_view_rounded,
                  label: 'Category',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _DrawerItem(
                  icon: Icons.collections_bookmark_outlined,
                  label: 'Collection',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _DrawerItem(
                  icon: Icons.favorite_border_rounded,
                  label: 'Favorites',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _DrawerItem(
                  icon: Icons.location_on_outlined,
                  label: 'Nearby',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _DrawerItem(
                  icon: Icons.quiz_outlined,
                  label: 'Quiz Challenge',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const QuizPage()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  onTap: () => Navigator.of(context).pop(),
                ),
                _DrawerItem(
                  icon: Icons.logout_rounded,
                  label: 'Sign Out',
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('user_email');
                    await prefs.remove('user_password');
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              final email = snapshot.data?.getString('user_email');
              final displayEmail = email == null || email.isEmpty
                  ? 'Guest account'
                  : email;
              final initials = _buildInitials(displayEmail);

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7EC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE3D3BE)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 21,
                        backgroundColor: const Color(0xFFD8AE73),
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Color(0xFF4A321B),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Profile',
                              style: TextStyle(
                                color: Color(0xFF9E7E5A),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              displayEmail,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF231408),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );
}

String _buildInitials(String value) {
  final parts = value.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
  final firstPart = parts.isNotEmpty ? parts.first : 'G';
  final secondPart = parts.length > 1 ? parts[1] : '';
  final firstInitial = firstPart.isNotEmpty ? firstPart[0].toUpperCase() : 'G';
  final secondInitial = secondPart.isNotEmpty ? secondPart[0].toUpperCase() : '';
  return '$firstInitial$secondInitial';
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      minLeadingWidth: 24,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, color: const Color(0xFF8C6500)),
      title: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF231408),
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE3D3BE)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF7A6655),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: Color(0xFF231408),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3D3BE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF8C6500)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF231408),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFF4F453A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7EC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE3D3BE)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF8C6500)),
      ),
    );
  }
}
