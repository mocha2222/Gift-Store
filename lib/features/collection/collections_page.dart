import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/home_mock_data.dart';
import '../../services/product_api.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_header.dart';
import 'widgets/collection_grid_item.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<CollectionItem> _allCollections = [];
  List<CollectionItem> _filteredCollections = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchCollections();
  }

  Future<void> _fetchCollections() async {
    try {
      final list = await ProductApi.getCollections();
      setState(() {
        _allCollections = list;
        _filteredCollections = list;
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
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredCollections = _allCollections;
      } else {
        _filteredCollections = _allCollections.where((c) {
          return c.name.toLowerCase().contains(query) ||
              c.occasion.toLowerCase().contains(query);
        }).toList();
      }
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),
                  Text(
                    'Our Collections',
                    style: GoogleFonts.cormorantGaramond(
                      color: const Color(0xFF2C261E),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle intro text
                  Text(
                    'Explore our handpicked selections categorized by recipients & special occasions, each crafted with love by local Cambodian master artisans.',
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
                        hintText: 'Search collections or occasions...',
                        hintStyle: GoogleFonts.inter(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF8C6500)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, color: Color(0xFF9E7E5A)),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Grid list of Collections
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: Color(0xFFD8AE73)),
                          )
                        : _errorMessage.isNotEmpty
                            ? Center(
                                child: Text(
                                  'Error loading collections: $_errorMessage',
                                  style: const TextStyle(color: Color(0xFFC0392B)),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : _filteredCollections.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.collections_outlined,
                                          size: 64,
                                          color: Color(0xFFC4B29A),
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          'No collections matched your search.',
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
                                    physics: const BouncingScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 14,
                                      mainAxisSpacing: 14,
                                      childAspectRatio: 0.82,
                                    ),
                                    itemCount: _filteredCollections.length,
                                    itemBuilder: (context, index) {
                                      return CollectionGridItem(item: _filteredCollections[index]);
                                    },
                                  ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
