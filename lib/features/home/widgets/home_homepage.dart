import 'package:flutter/material.dart';

import '../../../router/app_router.dart';
import '../../../services/product_api.dart';
import '../../profile/artisan_profile_page.dart';
import '../../../data/home_mock_data.dart';
import '../../../widgets/app_section_header.dart';

import 'search_bar_widget.dart';
import 'hero_card.dart';
import 'discipline_chip.dart';
import 'quiz_banner.dart';
import 'promo_card.dart';
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

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductApi.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: SearchBarWidget(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 18)),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                selected: index == _selectedDiscipline,
                onTap: () =>
                    setState(() => _selectedDiscipline = index),
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
              title: 'Special Offers',
              actionLabel: 'View All',
              onActionTap: () {},
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: promotions.length,
              itemBuilder: (context, index) =>
                  PromoCard(item: promotions[index]),
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
              onActionTap: () {},
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
        FutureBuilder<List<GiftItem>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFD8AE73)),
                  ),
                ),
              );
            }
            if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Failed to load products. ${snapshot.error}', style: const TextStyle(color: Color(0xFFC0392B))),
                ),
              );
            }
            
            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No products currently available.'),
                ),
              );
            }
            
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) => GiftCard(item: products[index]),
              ),
            );
          },
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
          child: SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: makers.length,
              itemBuilder: (context, index) {
                final maker = makers[index];
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
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}