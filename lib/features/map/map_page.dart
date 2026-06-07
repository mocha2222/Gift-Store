import 'package:flutter/material.dart';
import 'widgets/map_mock_data.dart';
import 'widgets/map_category_filter.dart';
import 'widgets/map_view.dart';
import 'widgets/nearby_shop_card.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String _selectedCategory = 'All';

  List<ShopLocation> get _filtered => _selectedCategory == 'All'
      ? shopLocations
      : shopLocations
          .where((s) => s.category == _selectedCategory)
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF6EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF6EE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: Color(0xFF231408)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Shop Locations',
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: Color(0xFF231408),
            )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded,
                color: Color(0xFFB8770D)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          MapCategoryFilter(
            selected: _selectedCategory,
            onSelect: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 260,
              child: MapView(
                shops: _filtered,
                selectedCategory: _selectedCategory,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Nearby Shops',
                    style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800,
                      color: Color(0xFF231408),
                    )),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB8770D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('${_filtered.length} shops',
                      style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600,
                        color: Color(0xFFB8770D),
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text('No shops in this category.',
                        style: TextStyle(color: Color(0xFF9E7E5A))),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) =>
                        NearbyShopCard(shop: _filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}