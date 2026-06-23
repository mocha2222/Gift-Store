import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/product_api.dart';
import '../../data/home_mock_data.dart';
import 'artisan_profile_page.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  late final Future<List<_FollowedArtisan>> _followingFuture;

  @override
  void initState() {
    super.initState();
    _followingFuture = _loadFollowing();
  }

  Future<List<_FollowedArtisan>> _loadFollowing() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('followed_artisans') ?? const [];
    return stored.map(_FollowedArtisan.fromStorage).toList();
  }

  void _openArtisan(_FollowedArtisan artisan) async {
    // Show a small loading overlay since we fetch from API now
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFD8AE73)),
      ),
    );

    try {
      final makerId = artisan.id.isNotEmpty ? artisan.id : 'unknown';
      final currentMaker = await ProductApi.getMakerDetails(makerId);
      
      if (!mounted) return;
      Navigator.of(context).pop(); // Dismiss loading

      final parts = currentMaker.role.split(' · ');
      final craft = parts.isNotEmpty ? parts.first : currentMaker.role;
      final region = parts.length > 1 ? parts.last : 'Cambodia';

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ArtisanProfilePage(
            artisanId: currentMaker.id,
            name: currentMaker.name,
            region: region,
            craft: craft,
            story: currentMaker.quote,
            avatarUrl: currentMaker.avatarUrl,
            followerCount: currentMaker.followerCount,
            products: currentMaker.products,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load artisan details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F0E4),
      appBar: AppBar(
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
          'Following',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF8C6500),
          ),
        ),
        backgroundColor: const Color(0xFFF7F0E4),
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF231408),
      ),
      body: FutureBuilder<List<_FollowedArtisan>>(
        future: _followingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final artisans = snapshot.data ?? const <_FollowedArtisan>[];
          if (artisans.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF7A4E2D), Color(0xFFB8770D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.people_outline_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'You are not following anyone yet',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF231408),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Open an artisan profile and tap Follow to see them here.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF9E7E5A),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: artisans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final artisan = artisans[index];
              final avatarUrl = artisan.avatarUrl;
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => _openArtisan(artisan),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7EC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2D3BE)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFD8AE73),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: () {
                          final initialsWidget = Center(
                            child: Text(
                              artisan.initials,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          );
                          if (avatarUrl == null || avatarUrl.isEmpty) {
                            return initialsWidget;
                          }
                          if (avatarUrl.startsWith('data:') || avatarUrl.length > 200) {
                            try {
                              String base64Str = avatarUrl;
                              if (base64Str.startsWith('data:')) {
                                final commaIndex = base64Str.indexOf(',');
                                if (commaIndex != -1) {
                                  base64Str = base64Str.substring(commaIndex + 1);
                                }
                              }
                              final bytes = base64Decode(base64Str.trim());
                              return Image.memory(bytes, fit: BoxFit.cover);
                            } catch (_) {
                              return initialsWidget;
                            }
                          }
                          if (avatarUrl.startsWith('http')) {
                            return Image.network(
                              avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => initialsWidget,
                            );
                          }
                          return Image.asset(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => initialsWidget,
                          );
                        }(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artisan.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cormorantGaramond(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF231408),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              artisan.region.isEmpty
                                  ? 'Artisan'
                                  : artisan.region,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8C6500),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              artisan.craft.isEmpty
                                  ? 'Handcrafted goods'
                                  : artisan.craft,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF9E7E5A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8C6500),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _FollowedArtisan {
  const _FollowedArtisan({
    required this.id,
    required this.name,
    required this.region,
    required this.craft,
    required this.story,
    required this.avatarUrl,
    required this.followerCount,
    required this.products,
  });

  final String id;

  final String name;
  final String region;
  final String craft;
  final String story;
  final String? avatarUrl;
  final int followerCount;
  final List<ArtisanProduct> products;

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'A';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  factory _FollowedArtisan.fromStorage(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) {
        String read(String key) => decoded[key]?.toString() ?? '';
        final rawProducts = decoded['products'];
        final products = rawProducts is List
            ? rawProducts
                  .whereType<Map>()
                  .map(
                    (item) => ArtisanProduct.fromJson(
                      item.map((key, entry) => MapEntry(key.toString(), entry)),
                    ),
                  )
                  .toList()
            : <ArtisanProduct>[];
        return _FollowedArtisan(
          id: read('id'),
          name: read('name'),
          region: read('region'),
          craft: read('craft'),
          story: read('story'),
          avatarUrl: read('avatarUrl').isEmpty
              ? (read('coverPhoto').isEmpty ? null : read('coverPhoto'))
              : read('avatarUrl'),
          followerCount: int.tryParse(read('followerCount')) ?? 128,
          products: products,
        );
      }
    } catch (_) {
      // Backward compatibility with old string-only entries.
    }

    return _FollowedArtisan(
      id: '',
      name: value,
      region: '',
      craft: '',
      story: '',
      avatarUrl: null,
      followerCount: 128,
      products: const [],
    );
  }
}
