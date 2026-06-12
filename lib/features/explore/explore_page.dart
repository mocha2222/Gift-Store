import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/home_mock_data.dart';
import '../../router/app_router.dart';
import '../../services/product_api.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_footer_nav.dart';
import '../../widgets/app_header.dart';
import '../collection/widgets/product_grid_item.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Future<List<GiftItem>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _productsFuture = ProductApi.getProducts();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase().trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF7F0E4),
      body: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: FutureBuilder<List<GiftItem>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD8AE73)),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load products: ${snapshot.error}'),
                  );
                }

                final allProducts = snapshot.data ?? [];
                
                final filteredProducts = allProducts.where((product) {
                  if (_searchQuery.isEmpty) return true;
                  return product.title.toLowerCase().contains(_searchQuery) ||
                      product.subtitle.toLowerCase().contains(_searchQuery);
                }).toList();

                final categories = <String, List<GiftItem>>{};
                for (var p in filteredProducts) {
                  categories.putIfAbsent(p.category, () => []).add(p);
                }

                final sections = <Widget>[];
                for (var entry in categories.entries) {
                  final catName = entry.key;
                  final catProducts = entry.value;
                  if (catProducts.isNotEmpty) {
                    sections.add(
                      _CollectionSection(
                        collection: CollectionItem(
                          name: catName,
                          occasion: 'Category',
                          itemCount: '${catProducts.length} items',
                          imageUrl: '',
                        ),
                        products: catProducts,
                      ),
                    );
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      Text(
                        'Explore Collections',
                        style: GoogleFonts.cormorantGaramond(
                          color: const Color(0xFF2C261E),
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Browse authentic Khmer treasures categorized by recipient and occasion, crafted by master Cambodian artisans.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF61584E),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7EC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2D3BE)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          cursorColor: const Color(0xFF8C6500),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF2C261E),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search products in collections...',
                            hintStyle: GoogleFonts.inter(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF8C6500),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                      color: Color(0xFF9E7E5A),
                                    ),
                                    onPressed: () => _searchController.clear(),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: sections.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.search_off_rounded,
                                      size: 64,
                                      color: Color(0xFFC4B29A),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      'No products matched your search.',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF7A6655),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.only(bottom: 24),
                                physics: const BouncingScrollPhysics(),
                                itemCount: sections.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 28),
                                itemBuilder: (context, index) => sections[index],
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SafeArea(top: false, child: AppFooterNav(currentIndex: 1)),
        ],
      ),
    );
  }
}

class _CollectionSection extends StatelessWidget {
  const _CollectionSection({required this.collection, required this.products});

  final CollectionItem collection;
  final List<GiftItem> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection.name,
                  style: GoogleFonts.cormorantGaramond(
                    color: const Color(0xFF2C261E),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  collection.occasion,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF8C6500),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.collectionDetail,
                  arguments: CollectionDetailArgs(collection: collection),
                );
              },
              icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              label: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF8C6500),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Horizontal list of products
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 170,
                child: ProductGridItem(item: products[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
