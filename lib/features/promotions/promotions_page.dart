import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../router/app_router.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_footer_nav.dart';
import '../../widgets/app_header.dart';
import 'widget/discount_product_model.dart';

import '../../services/product_api.dart';
import '../../data/home_mock_data.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  late Future<List<GiftItem>> _discountProductsFuture;

  @override
  void initState() {
    super.initState();
    _discountProductsFuture = ProductApi.getDiscountProducts();
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
              future: _discountProductsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFD8AE73)),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Color(0xFFC0392B)),
                    ),
                  );
                }
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return const Center(
                    child: Text('No discounted products found.'),
                  );
                }
                final discountProds = products.map((e) => DiscountProduct.fromGiftItem(e)).toList();

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 14),
                            Text(
                              'Discount Products',
                              style: GoogleFonts.cormorantGaramond(
                                color: const Color(0xFF2C261E),
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Browse products currently on discount — tap any item to view details and use the promo code at checkout.',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF61584E),
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 32),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final discount = discountProds[index];
                            return _DiscountProductTile(discount: discount);
                          },
                          childCount: discountProds.length,
                        ),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
          const SafeArea(top: false, child: AppFooterNav()),
        ],
      ),
    );
  }
}

class _DiscountProductTile extends StatelessWidget {
  const _DiscountProductTile({required this.discount});

  final DiscountProduct discount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.productDetail,
        arguments: ProductDetailArgs(item: discount.item),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7EC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2D3BE)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Accent Bar / Discount Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: discount.badgeColor,
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_offer_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${discount.discountPercent}% OFF',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          discount.item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: discount.item.accent.withValues(alpha: 0.2),
                            child: Icon(Icons.image_outlined,
                                color: discount.item.accent, size: 32),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            discount.item.title,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2C261E),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Was ${discount.originalPrice}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.brown.withOpacity(0.55),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Now ${discount.discountedPrice}',
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFFB8770D),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
