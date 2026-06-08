import 'package:flutter/material.dart';

import 'admin_models.dart';
import 'widgets/product_widgets.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  String? _artisanFilter;

  @override
  Widget build(BuildContext context) {
    final artisans = adminProducts.map((e) => e.artisan).toSet().toList()..sort();
    final filtered = _artisanFilter == null
        ? adminProducts
        : adminProducts.where((product) => product.artisan == _artisanFilter).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductToolbar(
            title: 'Product Management',
            subtitle: 'View all products, filter by artisan, and remove products when needed.',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: const Text('All artisans'),
                selected: _artisanFilter == null,
                onSelected: (_) => setState(() => _artisanFilter = null),
              ),
              ...artisans.map(
                (artisan) => ChoiceChip(
                  label: Text(artisan),
                  selected: _artisanFilter == artisan,
                  onSelected: (_) => setState(() => _artisanFilter = artisan),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 980 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisExtent: 170,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                ),
                itemBuilder: (context, index) {
                  final product = filtered[index];
                  return ProductCard(
                    product: product,
                    onDelete: () => setState(() => adminProducts.remove(product)),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
