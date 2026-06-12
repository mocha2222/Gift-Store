import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/home_mock_data.dart';
import '../../services/product_api.dart';
import '../auth/login_page.dart';
import 'widgets/profile_stats_row.dart';

class ArtisanProfilePage extends StatefulWidget {
  const ArtisanProfilePage({
    super.key,
    required this.artisanId,
    required this.name,
    required this.region,
    required this.craft,
    required this.story,
    required this.avatarUrl,
    required this.products,
    this.followerCount = 128,
  });

  final String artisanId;

  final String name;
  final String region;
  final String craft;
  final String story;
  final String? avatarUrl;
  final List<ArtisanProduct> products;
  final int followerCount;

  @override
  State<ArtisanProfilePage> createState() => _ArtisanProfilePageState();
}

class _ArtisanProfilePageState extends State<ArtisanProfilePage> {
  static const _followingKey = 'followed_artisans';

  bool _isFollowing = false;
  bool _isLoggedIn = false;
  late int _followerCount;

  bool _isLoadingProducts = false;
  List<ArtisanProduct> _fetchedProducts = [];

  List<ArtisanProduct> get _displayProducts {
    if (_fetchedProducts.isNotEmpty) {
      return _fetchedProducts;
    }

    final avatarUrl = widget.avatarUrl ?? '';
    if (avatarUrl.contains('Silk-wallet.jpg')) {
      return const [
        ArtisanProduct(
          title: 'Silk Wallet',
          price: '\$22.00',
          imagePath: 'assets/images/products/Silk-wallet.jpg',
        ),
        ArtisanProduct(
          title: 'Coin Pouch',
          price: '\$16.00',
          imagePath: 'assets/images/products/Silk-wallet.jpg',
        ),
        ArtisanProduct(
          title: 'Passport Sleeve',
          price: '\$24.00',
          imagePath: 'assets/images/products/Silk-wallet.jpg',
        ),
        ArtisanProduct(
          title: 'Card Holder',
          price: '\$19.00',
          imagePath: 'assets/images/products/Silk-wallet.jpg',
        ),
      ];
    }

    return const [
      ArtisanProduct(
        title: 'Handwoven Scarf',
        price: '\$28.00',
        imagePath: 'assets/images/products/Krama.jpg',
      ),
      ArtisanProduct(
        title: 'Krama Wrap',
        price: '\$34.00',
        imagePath: 'assets/images/products/Krama.jpg',
      ),
      ArtisanProduct(
        title: 'Wooden Bowl',
        price: '\$29.00',
        imagePath: 'assets/images/products/Krama.jpg',
      ),
      ArtisanProduct(
        title: 'Keepsake Box',
        price: '\$36.00',
        imagePath: 'assets/images/products/Krama.jpg',
      ),
    ];
  }

  Map<String, dynamic> get _artisanRecord => {
    'id': widget.artisanId,
    'name': widget.name,
    'region': widget.region,
    'craft': widget.craft,
    'story': widget.story,
    'avatarUrl': widget.avatarUrl ?? '',
    'followerCount': widget.followerCount,
    'products': _displayProducts.map((product) => product.toJson()).toList(),
  };

  @override
  void initState() {
    super.initState();
    _followerCount = widget.followerCount;
    _fetchedProducts = widget.products;
    _loadLoginState();
    _loadFollowState();
    if (widget.artisanId.isNotEmpty) {
      _fetchProducts();
    }
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoadingProducts = true);
    try {
      // Import needed if not present
      final details = await ProductApi.getMakerDetails(widget.artisanId);
      if (mounted) {
        setState(() {
          _fetchedProducts = details.products;
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProducts = false);
      }
    }
  }

  Future<void> _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isLoggedIn = (prefs.getString('user_email') ?? '').isNotEmpty;
    });
  }

  Future<void> _loadFollowState() async {
    final prefs = await SharedPreferences.getInstance();
    final followed = prefs.getStringList(_followingKey) ?? const [];

    if (!mounted) return;
    setState(() {
      _isFollowing = followed.any(
        (entry) => _decodeFollowRecord(entry)['name'] == widget.name,
      );
    });
  }

  Future<void> _toggleFollow() async {
    if (!_isLoggedIn) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const LoginPage()));
      await _loadLoginState();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final followed = prefs.getStringList(_followingKey)?.toList() ?? <String>[];
    final records = followed.map(_decodeFollowRecord).toList();

    if (_isFollowing) {
      records.removeWhere((record) => record['name'] == widget.name);
    } else if (!records.any((record) => record['name'] == widget.name)) {
      records.add(_artisanRecord);
    }

    await prefs.setStringList(
      _followingKey,
      records.map((record) => jsonEncode(record)).toList(),
    );
    if (!mounted) return;
    final wasFollowing = _isFollowing;
    setState(() {
      _isFollowing = !wasFollowing;
      _followerCount = wasFollowing
          ? (_followerCount > 0 ? _followerCount - 1 : 0)
          : _followerCount + 1;
    });
  }

  Map<String, dynamic> _decodeFollowRecord(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) {
        return decoded.map((key, entry) => MapEntry(key.toString(), entry));
      }
    } catch (_) {
      // Backward compatibility with the old string-only format.
    }

    return {'name': value};
  }

  String get _initials {
    final words = widget.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return 'A';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEAD5A8)),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF231408),
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          widget.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF231408),
          ),
        ),
        backgroundColor: const Color(0xFFF7F0E4),
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF231408),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD8AE73),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipOval(
                        child:
                            widget.avatarUrl != null &&
                                widget.avatarUrl!.isNotEmpty
                            ? (widget.avatarUrl!.startsWith('http')
                                ? Image.network(
                                    widget.avatarUrl!,
                                    fit: BoxFit.cover,
                                    width: 64,
                                    height: 64,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Text(
                                        _initials,
                                        style: GoogleFonts.cormorantGaramond(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF4A321B),
                                        ),
                                      ),
                                    ),
                                  )
                                : Image.asset(
                                    widget.avatarUrl!,
                                    fit: BoxFit.cover,
                                    width: 64,
                                    height: 64,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Text(
                                        _initials,
                                        style: GoogleFonts.cormorantGaramond(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF4A321B),
                                        ),
                                      ),
                                    ),
                                  ))
                            : Center(
                                child: Text(
                                  _initials,
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF4A321B),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF231408),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Color(0xFF8C6500),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.region,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF8C6500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.brush_outlined,
                                color: Color(0xFF8C6500),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.craft,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF8C6500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 44,
                  child: FilledButton.icon(
                    onPressed: _toggleFollow,
                    icon: Icon(
                      !_isLoggedIn
                          ? Icons.lock_outline_rounded
                          : (_isFollowing
                                ? Icons.check_circle_outline_rounded
                                : Icons.person_add_alt_1_rounded),
                      size: 18,
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: !_isLoggedIn
                          ? const Color(0xFFF1E7D5)
                          : (_isFollowing
                                ? const Color(0xFFF1E7D5)
                                : const Color(0xFFD8AE73)),
                      foregroundColor: const Color(0xFF4A321B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: _isFollowing && _isLoggedIn
                            ? const BorderSide(color: Color(0xFFE2D3BE))
                            : BorderSide.none,
                      ),
                    ),
                    label: Text(
                      !_isLoggedIn
                          ? 'Sign in to Follow'
                          : (_isFollowing ? 'Following' : 'Follow'),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  !_isLoggedIn
                      ? 'Sign in to follow ${widget.name} and save them to your list.'
                      : (_isFollowing
                            ? 'You are following ${widget.name}. New items from this artisan will appear in your feed.'
                            : 'Follow ${widget.name} to get updates about new handcrafted items and stories.'),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF6A5A47),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                ProfileStatsRow(
                  stats: [
                    (
                      label: 'Products',
                      value: _displayProducts.length.toString(),
                    ),
                    (label: 'Followers', value: _followerCount.toString()),
                    (label: 'Rating', value: '4.9★'),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7EC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2D3BE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Story',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF8C6500),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.story,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF5E5244),
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Products',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF231408),
                  ),
                ),
                const SizedBox(height: 12),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _isLoadingProducts
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFFD8AE73)),
                    ),
                  )
                : SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ItemCard(item: _displayProducts[index]),
                      childCount: _displayProducts.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({required this.item});

  final ArtisanProduct item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2D3BE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: const BoxDecoration(color: Color(0xFFF1E7D5)),
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Color(0xFFD8AE73),
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF231408),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.price,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF8C6500),
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
