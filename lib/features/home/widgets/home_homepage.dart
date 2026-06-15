import 'package:flutter/material.dart';

import '../../../router/app_router.dart';
import '../../../services/product_api.dart';
import '../../profile/artisan_profile_page.dart';
import '../../../data/home_mock_data.dart';
import '../../../widgets/app_section_header.dart';

import 'hero_card.dart';
import 'discipline_chip.dart';
import 'quiz_banner.dart';
import 'promo_card.dart';
import 'discount_product_card.dart';
import '../../promotions/widget/discount_product_model.dart';
import 'collection_card.dart';
import 'gift_card.dart';
import 'maker_card.dart';

class HomeHomepage extends StatefulWidget {
  const HomeHomepage({super.key});

  @override
  State<HomeHomepage> createState() => _HomeHomepageState();
}

class _HomeHomepageState extends State<HomeHomepage> {
  int _selectedDiscipline = 0;
  late Future<List<GiftItem>> _productsFuture;
  late Future<List<MakerItem>> _makersFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductApi.getProducts();
    _makersFuture = ProductApi.getMakers();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: HeroCard(onPressed: () {}),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Curated Disciplines',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF231408),
                  ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 105,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemCount: disciplines.length,
              itemBuilder: (context, index) => DisciplineChip(
                item: disciplines[index],
                selected: false,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.category,
                    arguments: disciplines[index].label,
                  );
                },
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: QuizBanner(
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.quiz),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppSectionHeader(
              title: 'Discount Products',
              actionLabel: 'View All',
              onActionTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.promotions),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: discountProducts.length,
              itemBuilder: (context, index) =>
                  DiscountProductCard(discount: discountProducts[index]),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppSectionHeader(
              title: 'Curated Collections',
              actionLabel: 'View All',
              onActionTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.collections),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: collections.length,
              itemBuilder: (context, index) =>
                  CollectionCard(item: collections[index]),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppSectionHeader(
              title: 'Trending Gifts',
              actionLabel: 'View All',
              onActionTap: () {},
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: FutureBuilder<List<GiftItem>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              // Loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFD8AE73)),
                  ),
                );
              }
              // Error
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Failed to load products. ${snapshot.error}',
                    style: const TextStyle(color: Color(0xFFC0392B)),
                  ),
                );
              }
              // Empty
              final products = snapshot.data ?? [];
              if (products.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No products currently available.'),
                );
              }
              // Product list
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (int i = 0; i < products.length; i++) ...[
                      GiftCard(item: products[i]),
                      if (i < products.length - 1)
                        const SizedBox(height: 16),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Meet the Makers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF231408),
                  ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        SliverToBoxAdapter(
          child: FutureBuilder<List<MakerItem>>(
            future: _makersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 280,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFD8AE73)),
                  ),
                );
              }
              if (snapshot.hasError) {
                return SizedBox(
                  height: 280,
                  child: Center(
                    child: Text('Failed to load makers: ${snapshot.error}'),
                  ),
                );
              }
              final loadedMakers = snapshot.data ?? [];
              if (loadedMakers.isEmpty) {
                return const SizedBox(
                  height: 280,
                  child: Center(child: Text('No makers found.')),
                );
              }
              
              return SizedBox(
                height: 280,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemCount: loadedMakers.length,
                  itemBuilder: (context, index) {
                    final maker = loadedMakers[index];
                    final parts = maker.role.split(' · ');
                    final craft =
                        parts.isNotEmpty ? parts.first : maker.role;
                    final region = parts.length > 1 ? parts.last : '';

                    return MakerCard(
                      item: maker,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ArtisanProfilePage(
                              artisanId: maker.id,
                              name: maker.name,
                              region: region,
                              craft: craft,
                              story: maker.quote,
                              followerCount: maker.followerCount,
                              avatarUrl: maker.avatarUrl,
                              products: maker.products,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}