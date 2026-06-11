import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../router/app_router.dart';
import 'widgets/artisan_product_model.dart';
import 'widgets/artisan_product_card.dart';
import 'widgets/add_edit_product_sheet.dart';
import 'widgets/artisan_dashboard_header.dart';
import '../../services/product_api.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_drawer.dart';

class ArtisanProductsPage extends StatefulWidget {
  const ArtisanProductsPage({super.key});

  @override
  State<ArtisanProductsPage> createState() => _ArtisanProductsPageState();
}

class _ArtisanProductsPageState extends State<ArtisanProductsPage> {
  String _artisanName  = 'Artisan';
  String _artisanCraft = 'Khmer Craftsperson';
  String _selectedCategory = 'All';

  List<ArtisanProductModel> _products = [];
  bool _isLoading = true;
  String? _artisanId;

  @override
  void initState() {
    super.initState();
    _loadArtisanInfo();
  }

  Future<void> _loadArtisanInfo() async {
    final prefs = await SharedPreferences.getInstance();
    var artisanId = prefs.getString('artisan_id');
    debugPrint('[ArtisanShellPage] artisan_id from prefs: $artisanId');
    debugPrint('[ArtisanShellPage] user_id from prefs: ${prefs.getString('user_id')}');
    
    // If artisan_id is missing, try to fetch it using the auth token
    if (artisanId == null || artisanId.isEmpty) {
      try {
        final token = prefs.getString('access_token');
        final userId = prefs.getString('user_id');
        if (token != null && userId != null) {
          final uri = Uri.parse('http://localhost:3000/api/artisans/by-user/$userId');
          final res = await http.get(uri, headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          });
          debugPrint('[ArtisanShellPage] artisan lookup response: ${res.statusCode} ${res.body}');
          if (res.statusCode == 200) {
            final body = jsonDecode(res.body);
            artisanId = body['_id']?.toString();
            if (artisanId != null && artisanId.isNotEmpty) {
              await prefs.setString('artisan_id', artisanId);
            }
          }
        }
      } catch (e) {
        debugPrint('[ArtisanShellPage] Error fetching artisan_id: $e');
      }
    }
    
    setState(() {
      _artisanName  = prefs.getString('user_name')  ?? 'Artisan';
      _artisanCraft = prefs.getString('user_craft') ?? 'Khmer Craftsperson';
      _artisanId = artisanId;
    });
    if (artisanId != null && artisanId.isNotEmpty) {
      await _fetchProducts();
    } else {
      debugPrint('[ArtisanShellPage] No artisan_id found, showing empty state');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchProducts() async {
    if (_artisanId == null) return;
    try {
      setState(() => _isLoading = true);
      final products = await ProductApi.getArtisanProducts(_artisanId!);
      setState(() {
        _products = products;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
    if (result == true) {
      _fetchProducts();
    }
  }

  Future<void> _openEditSheet(ArtisanProductModel product) async {
    final result = await AddEditProductSheet.show(
        context, existing: product);
    if (result == true) {
      _fetchProducts();
    }
  }

  Future<void> _deleteProduct(String id) async {
    try {
      await ProductApi.deleteProduct(id);
      _fetchProducts();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting product: $e')));
    }
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
    return Container(
      color: const Color(0xFFFBF6EE),
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
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator()) 
                  : _filtered.isEmpty
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