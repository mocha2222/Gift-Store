import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../router/app_router.dart';
import '../../services/product_api.dart';
import 'widgets/add_edit_product_sheet.dart';
import 'widgets/artisan_dashboard_section.dart';
import 'widgets/artisan_hero_panel.dart';
import 'widgets/artisan_order_row.dart';
import 'widgets/artisan_stat_card.dart';
import 'widgets/artisan_product_model.dart';

class ArtisanDashboardPage extends StatefulWidget {
  final VoidCallback? onNavigateToProducts;
  final VoidCallback? onNavigateToOrders;

  const ArtisanDashboardPage({
    super.key,
    this.onNavigateToProducts,
    this.onNavigateToOrders,
  });

  @override
  State<ArtisanDashboardPage> createState() => _ArtisanDashboardPageState();
}

class _ArtisanDashboardPageState extends State<ArtisanDashboardPage> {
  static const Color backgroundColor = Color(0xFFF7F0E4);
  static const Color surfaceColor = Color(0xFFFBF5EA);
  static const Color primaryColor = Color(0xFF8C6500);
  static const Color textDarkColor = Color(0xFF2C261E);
  static const Color textMutedColor = Color(0xFF5F564C);

  bool _isLoading = true;
  String _artisanId = '';
  List<ArtisanProductModel> _products = [];
  List<Map<String, dynamic>> _orders = [];
  String _revenueStr = '\$0.00';
  int _pendingCount = 0;
  int _lowStockCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    var artisanId = prefs.getString('artisan_id') ?? '';

    if (artisanId.isEmpty) {
      try {
        final token = prefs.getString('access_token');
        final userId = prefs.getString('user_id');
        if (token != null && userId != null) {
          final uri = Uri.parse('${ProductApi.baseUrl}/artisans/by-user/$userId');
          var res = await http.get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
          
          if (res.statusCode == 404) {
            // Fallback: fetch all makers and find the matching user_id
            final makersRes = await http.get(
              Uri.parse('${ProductApi.baseUrl}/artisans'),
              headers: {'Content-Type': 'application/json'},
            );
            if (makersRes.statusCode == 200) {
              final List<dynamic> makersList = jsonDecode(makersRes.body);
              for (final makerJson in makersList) {
                final mUserId = makerJson['user_id'];
                final mUserIdStr = mUserId is Map ? mUserId['_id']?.toString() ?? mUserId['id']?.toString() : mUserId?.toString();
                if (mUserIdStr == userId) {
                  res = http.Response(jsonEncode(makerJson), 200);
                  break;
                }
              }
            }
          }
          
          if (res.statusCode == 200) {
            final body = jsonDecode(res.body);
            artisanId = body['_id']?.toString() ?? body['id']?.toString() ?? '';
            if (artisanId.isNotEmpty) {
              await prefs.setString('artisan_id', artisanId);
            }
          }
        }
      } catch (e) {
        debugPrint('[ArtisanDashboard] Error fetching artisan_id: $e');
      }
    }

    if (artisanId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final products = await ProductApi.getArtisanProducts(artisanId);
      final orders = await ProductApi.getArtisanOrders(artisanId);

      double totalRevenue = 0.0;
      int pending = 0;
      for (final order in orders) {
        final status = order['status']?.toString().toLowerCase() ?? '';
        if (status == 'pending') {
          pending++;
        }
        if (status != 'cancelled') {
          totalRevenue += (order['total_price'] as num?)?.toDouble() ?? 0.0;
        }
      }

      final lowStock = products.where((p) => p.stock < 5).length;

      if (mounted) {
        setState(() {
          _artisanId = artisanId;
          _products = products;
          _orders = orders;
          _revenueStr = '\$${totalRevenue.toStringAsFixed(2)}';
          _pendingCount = pending;
          _lowStockCount = lowStock;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[ArtisanDashboard] Error loading dashboard data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatStatus(String status) {
    if (status.isEmpty) return 'Pending';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  String _getOrderProductNames(Map<String, dynamic> order) {
    final itemsList = order['items'] as List<dynamic>? ?? [];
    if (itemsList.isEmpty) return 'Handcrafted Gift';
    final names = itemsList.map((item) {
      final prod = item['product_id'];
      if (prod is Map) {
        return prod['name']?.toString() ?? 'Handcrafted Gift';
      }
      return 'Handcrafted Gift';
    }).toList();
    return names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    const bool hasUnreadMessages = true;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: primaryColor),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: primaryColor,
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    sliver: SliverToBoxAdapter(
                      child: ArtisanHeroPanel(
                        onOpenMessages: () => _openChat(context),
                        onOpenNotifications: () => _openNotifications(context),
                        onManageProduct: () => _openArtisanPage(context),
                        pendingCount: _pendingCount,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    sliver: SliverToBoxAdapter(
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.05,
                        children: [
                          ArtisanStatCard(
                            label: 'Total Orders',
                            value: _orders.length.toString(),
                            icon: Icons.shopping_bag_outlined,
                            accentColor: const Color(0xFF5B7FA6),
                            subtitle: '$_pendingCount pending today',
                          ),
                          ArtisanStatCard(
                            label: 'Revenue',
                            value: _revenueStr,
                            icon: Icons.attach_money_rounded,
                            accentColor: const Color(0xFF6B4C9A),
                            subtitle: 'Lifetime sales',
                          ),
                          ArtisanStatCard(
                            label: 'Total Products',
                            value: _products.length.toString(),
                            icon: Icons.inventory_2_outlined,
                            accentColor: const Color(0xFF4A7C59),
                            subtitle: '$_lowStockCount low stock items',
                          ),
                          const ArtisanStatCard(
                            label: 'Avg Rating',
                            value: '4.8',
                            icon: Icons.star_outline_rounded,
                            accentColor: Color(0xFFB8770D),
                            subtitle: '96% positive feedback',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ArtisanSectionHeader(
                            title: 'Recent Orders',
                            actionLabel: 'See all',
                            onActionTap: () {
                              if (widget.onNavigateToOrders != null) {
                                widget.onNavigateToOrders!();
                              } else {
                                Navigator.of(context).pushNamed(AppRoutes.artisanOrders);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          ArtisanDashboardSection(
                            child: _orders.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Center(
                                      child: Text(
                                        'No orders received yet.',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: textMutedColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _orders.length > 5 ? 5 : _orders.length,
                                    separatorBuilder: (_, __) => const Divider(
                                      height: 16,
                                      color: Color(0xFFE2D3BE),
                                    ),
                                    itemBuilder: (context, index) {
                                      final order = _orders[index];
                                      final user = order['user_id'];
                                      final customerName = user is Map
                                          ? user['name']?.toString() ?? 'Customer'
                                          : 'Customer';
                                      final pNames = _getOrderProductNames(order);
                                      final total = '\$${(order['total_price'] as num?)?.toStringAsFixed(2) ?? '0.00'}';
                                      final status = _formatStatus(order['status']?.toString() ?? 'pending');

                                      return ArtisanOrderRow(
                                        customerName: customerName,
                                        productName: pNames,
                                        amount: total,
                                        status: status,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (hasUnreadMessages)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7EC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE2D3BE)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline_rounded,
                                  color: primaryColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Keep your chats updated with customers',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: textDarkColor,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => _openChat(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: primaryColor,
                                ),
                                child: Text(
                                  'Go to Chat',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openNotifications(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.artisanNotifications);
  }

  void _openChat(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.artisanChat);
  }

  void _openArtisanPage(BuildContext context) {
    if (widget.onNavigateToProducts != null) {
      widget.onNavigateToProducts!();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.artisan);
    }
  }

  void _addProduct(BuildContext context) {
    AddEditProductSheet.show(context).then((_) => _loadData());
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF8C6500).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: const Color(0xFF8C6500)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C261E),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9E7E5A),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
