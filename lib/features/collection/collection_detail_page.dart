import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/home_mock_data.dart';
import '../../services/product_api.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_footer_nav.dart';
import '../../widgets/app_header.dart';
import 'widgets/product_grid_item.dart';

class CollectionDetailPage extends StatefulWidget {
  const CollectionDetailPage({super.key, required this.collection});

  final CollectionItem collection;

  @override
  State<CollectionDetailPage> createState() => _CollectionDetailPageState();
}

class _CollectionDetailPageState extends State<CollectionDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = 'Default';
  List<GiftItem> _allProducts = [];
  List<GiftItem> _displayProducts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchOrSortChanged);
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final list = await ProductApi.getCollectionProducts(widget.collection.id);
      setState(() {
        _allProducts = list;
        _displayProducts = List.from(list);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchOrSortChanged);
    _searchController.dispose();
    super.dispose();
  }

  double _parsePrice(String priceStr) {
    try {
      return double.parse(priceStr.replaceAll(RegExp(r'[^\d.]'), ''));
    } catch (_) {
      return 0.0;
    }
  }

  void _onSearchOrSortChanged() {
    final query = _searchController.text.toLowerCase().trim();
    
    // 1. Filter
    List<GiftItem> temp = _allProducts;
    if (query.isNotEmpty) {
      temp = temp.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.subtitle.toLowerCase().contains(query);
      }).toList();
    }

    // 2. Sort
    if (_selectedSort == 'Price: Low to High') {
      temp.sort((a, b) => _parsePrice(a.price).compareTo(_parsePrice(b.price)));
    } else if (_selectedSort == 'Price: High to Low') {
      temp.sort((a, b) => _parsePrice(b.price).compareTo(_parsePrice(a.price)));
    } else if (_selectedSort == 'Rating') {
      // For rating, they're mostly 4.8 in mocks, but we sort descending
      // In case we want to sort, we keep original index fallback
    }

    setState(() {
      _displayProducts = temp;
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
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Parallax / Collapsing Header Image
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  backgroundColor: const Color(0xFFF7F0E4),
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xB3FFF7EC),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF2C261E),
                          size: 18,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    title: LayoutBuilder(
                      builder: (context, constraints) {
                        // Only show title text in app bar when collapsed
                        final isCollapsed = constraints.biggest.height <= kToolbarHeight + 50;
                        return Text(
                          isCollapsed ? widget.collection.name : '',
                          style: GoogleFonts.cormorantGaramond(
                            color: const Color(0xFF2C261E),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.collection.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: const Color(0xFFF1E7D5)),
                        ),
                        // Dark gradient overlay
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0x33000000),
                                Color(0x99000000),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Overlaid collection info
                        Positioned(
                          bottom: 24,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD8AE73),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  widget.collection.occasion.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF4A321B),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.collection.name,
                                style: GoogleFonts.cormorantGaramond(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black38,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                '${_allProducts.length} items curated with Cambodian artisans',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Filters & Search Bar Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Inner search bar
                            Expanded(
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7EC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE2D3BE)),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  cursorColor: const Color(0xFF8C6500),
                                  style: GoogleFonts.inter(fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: 'Search in this collection...',
                                    hintStyle: GoogleFonts.inter(
                                      color: const Color(0xFF9CA3AF),
                                      fontSize: 13,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      color: Color(0xFF8C6500),
                                      size: 18,
                                    ),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () => _searchController.clear(),
                                            child: const Icon(
                                              Icons.clear_rounded,
                                              color: Color(0xFF9E7E5A),
                                              size: 18,
                                            ),
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Sort dropdown menu
                            Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF7EC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2D3BE)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedSort,
                                  icon: const Icon(Icons.swap_vert_rounded, color: Color(0xFF8C6500), size: 18),
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF2C261E),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  dropdownColor: const Color(0xFFFFF7EC),
                                  borderRadius: BorderRadius.circular(12),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      _selectedSort = newValue;
                                      _onSearchOrSortChanged();
                                    }
                                  },
                                  items: <String>['Default', 'Price: Low to High', 'Price: High to Low']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Grid display of Products
                _isLoading
                    ? const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(color: Color(0xFFD8AE73)),
                        ),
                      )
                    : _errorMessage.isNotEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Text(
                                'Error loading products: $_errorMessage',
                                style: const TextStyle(color: Color(0xFFC0392B)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : _displayProducts.isEmpty
                            ? const SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 48,
                                        color: Color(0xFFC4B29A),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'No products found matching your search.',
                                        style: TextStyle(
                                          color: Color(0xFF7A6655),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SliverPadding(
                                padding: const EdgeInsets.fromLTRB(18, 0, 18, 32),
                                sliver: SliverGrid(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                    childAspectRatio: 0.68,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return ProductGridItem(item: _displayProducts[index]);
                                    },
                                    childCount: _displayProducts.length,
                                  ),
                                ),
                              ),
              ],
            ),
          ),
          const SafeArea(top: false, child: AppFooterNav(currentIndex: 1)),
        ],
      ),
    );
  }
}
