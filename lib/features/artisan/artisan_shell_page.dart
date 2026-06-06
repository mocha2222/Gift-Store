import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../router/app_router.dart';
import 'widgets/artisan_product_model.dart';
import 'widgets/artisan_product_card.dart';
import 'widgets/add_edit_product_sheet.dart';
import 'widgets/artisan_dashboard_header.dart';

class ArtisanShellPage extends StatefulWidget {
  const ArtisanShellPage({super.key});

  @override
  State<ArtisanShellPage> createState() => _ArtisanShellPageState();
}

class _ArtisanShellPageState extends State<ArtisanShellPage> {
  String _artisanName  = 'Artisan';
  String _artisanCraft = 'Khmer Craftsperson';
  String _selectedCategory = 'All';

  final List<ArtisanProductModel> _products = [
    ArtisanProductModel(
      id: 'demo1',
      title: 'Hand-woven Silk Krama',
      description: 'Natural indigo dye, traditional Takeo weave.',
      price: '\$28.00',
      category: 'Silk',
      imagePath:
          'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=400&q=80',
    ),
    ArtisanProductModel(
      id: 'demo2',
      title: 'Silver Apsara Bracelet',
      description: 'Hand-chased sterling silver, Phnom Penh.',
      price: '\$42.00',
      category: 'Silver',
      imagePath:
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadArtisanInfo();
  }

  Future<void> _loadArtisanInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _artisanName  = prefs.getString('user_name')  ?? 'Artisan';
      _artisanCraft = prefs.getString('user_craft') ?? 'Khmer Craftsperson';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  List<ArtisanProductModel> get _filtered => _selectedCategory == 'All'
      ? _products
      : _products
          .where((p) => p.category == _selectedCategory)
          .toList();

  Future<void> _openAddSheet() async {
    final result = await AddEditProductSheet.show(context);
    if (result != null) {
      setState(() => _products.add(result));
    }
  }

  Future<void> _openEditSheet(ArtisanProductModel product) async {
    final result = await AddEditProductSheet.show(
        context, existing: product);
    if (result != null) {
      setState(() {
        final idx = _products.indexWhere((p) => p.id == product.id);
        if (idx != -1) _products[idx] = result;
      });
    }
  }

  void _deleteProduct(String id) {
    setState(() => _products.removeWhere((p) => p.id == id));
  }

  void _toggleAvailability(String id) {
    setState(() {
      final idx = _products.indexWhere((p) => p.id == id);
      if (idx != -1) {
        _products[idx] = _products[idx].copyWith(
            isAvailable: !_products[idx].isAvailable);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6EE),
      body: SafeArea(
        child: Column(
          children: [
            ArtisanDashboardHeader(
              name: _artisanName,
              craft: _artisanCraft,
              productCount: _products.length,
              onLogout: _logout,
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                const Text('My Products',
                    style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800,
                      color: Color(0xFF231408),
                    )),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _openAddSheet,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add Product'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFB8770D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  'All', ...artisanCategories,
                ].map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFB8770D)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFB8770D)
                              : const Color(0xFFEAD5A8),
                        ),
                      ),
                      child: Text(cat,
                          style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF5E4A35),
                          )),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filtered.length,
                      itemBuilder: (context, i) {
                        final p = _filtered[i];
                        return ArtisanProductCard(
                          product: p,
                          onEdit: () => _openEditSheet(p),
                          onDelete: () => _deleteProduct(p.id),
                          onToggleAvailability: () =>
                              _toggleAvailability(p.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          const Text('No products yet',
              style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: Color(0xFF231408),
              )),
          const SizedBox(height: 6),
          const Text('Tap "Add Product" to list your first item.',
              style: TextStyle(color: Color(0xFF9E7E5A), fontSize: 13)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _openAddSheet,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Product'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB8770D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}