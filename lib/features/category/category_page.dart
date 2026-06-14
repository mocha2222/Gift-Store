import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/home_mock_data.dart';
import '../../router/app_router.dart';
import '../../services/category_api.dart';
import '../../services/product_api.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_footer_nav.dart';
import '../../widgets/app_header.dart';
import '../collection/widgets/product_grid_item.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, this.initialCategoryName});

  final String? initialCategoryName;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  List<CategoryModel> _categories = [];
  String? _selectedCategoryId; // null means "All"
  List<GiftItem> _products = [];
  bool _isLoadingCategories = true;
  bool _isLoadingProducts = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
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

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoadingCategories = true;
        _error = null;
      });
      
      final categories = await CategoryApi.getCategories();
      
      String? targetCategoryId;
      if (widget.initialCategoryName != null) {
        final mappedName = _mapDisciplineName(widget.initialCategoryName!);
        final matchingCategory = categories.firstWhere(
          (c) => c.name.toLowerCase() == mappedName || c.name.toLowerCase() == widget.initialCategoryName!.toLowerCase(),
          orElse: () => CategoryModel(id: '', name: ''),
        );
        if (matchingCategory.id.isNotEmpty) {
          targetCategoryId = matchingCategory.id;
        }
      }

      setState(() {
        _categories = categories;
        _selectedCategoryId = targetCategoryId;
        _isLoadingCategories = false;
      });

      await _fetchProducts();
    } catch (e) {
      setState(() {
        _error = 'Failed to load categories: $e';
        _isLoadingCategories = false;
        _isLoadingProducts = false;
      });
    }
  }

  String _mapDisciplineName(String name) {
    if (name.toLowerCase() == 'silk') return 'silk';
    return name.toLowerCase();
  }

  Future<void> _fetchProducts() async {
    try {
      setState(() {
        _isLoadingProducts = true;
        _error = null;
      });

      final products = await ProductApi.getProducts(categoryId: _selectedCategoryId);
      
      setState(() {
        _products = products;
        _isLoadingProducts = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load products: $e';
        _isLoadingProducts = false;
      });
    }
  }

  void _onCategorySelected(String? categoryId) {
    if (_selectedCategoryId == categoryId) return;
    setState(() {
      _selectedCategoryId = categoryId;
    });
    _fetchProducts();
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'silk':
        return Icons.waves_rounded;
      case 'silver':
        return Icons.diamond_outlined;
      case 'wood':
        return Icons.park_outlined;
      case 'edible':
        return Icons.spa_outlined;
      case 'jewelry':
        return Icons.auto_awesome_outlined;
      default:
        return Icons.grid_view_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _products.where((product) {
      if (_searchQuery.isEmpty) return true;
      return product.title.toLowerCase().contains(_searchQuery) ||
          product.subtitle.toLowerCase().contains(_searchQuery) ||
          product.story.toLowerCase().contains(_searchQuery);
    }).toList();

    Widget bodyContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 14),
          Text(
            'Browse Disciplines',
            style: GoogleFonts.cormorantGaramond(
              color: const Color(0xFF2C261E),
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explore authentic creations by category, handmade by Cambodian master artisans.',
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
                hintText: 'Search products in category...',
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
          const SizedBox(height: 18),

          // Category Chips Row
          if (_isLoadingCategories)
            const SizedBox(
              height: 50,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF8C6500),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: _categories.length + 1,
                itemBuilder: (context, idx) {
                  final isAll = idx == 0;
                  final cat = isAll ? null : _categories[idx - 1];
                  final isSelected = isAll 
                      ? _selectedCategoryId == null 
                      : _selectedCategoryId == cat!.id;
                  final label = isAll ? 'All' : cat!.name;
                  final icon = isAll ? Icons.grid_view_rounded : _getCategoryIcon(cat!.name);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(
                        icon,
                        size: 16,
                        color: isSelected ? Colors.white : const Color(0xFF8C6500),
                      ),
                      label: Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? Colors.white : const Color(0xFF4F453A),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF8C6500),
                      backgroundColor: const Color(0xFFFFF7EC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFF8C6500) : const Color(0xFFE2D3BE),
                        ),
                      ),
                      onSelected: (_) => _onCategorySelected(isAll ? null : cat?.id),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 20),

          // Products Grid
          Expanded(
            child: _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style: GoogleFonts.inter(color: Colors.red, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _isLoadingProducts
                    ? const Center(
                        child: CircularProgressIndicator(color: Color(0xFF8C6500)),
                      )
                    : filteredProducts.isEmpty
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
                                  'No products found in this category.',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF7A6655),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.only(bottom: 24),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.68,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              return ProductGridItem(item: filteredProducts[index]);
                            },
                          ),
          ),
        ],
      ),
    );

    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF7F0E4),
      body: Column(
        children: [
          const AppHeader(),
          Expanded(child: bodyContent),
          const SafeArea(top: false, child: AppFooterNav(currentIndex: 99)),
        ],
      ),
    );
  }
}
