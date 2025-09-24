import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/product_base.dart';
import '../widgets/product_card.dart';

class CategoryListing extends ConsumerWidget {
  final String categorySlug;

  const CategoryListing({super.key, required this.categorySlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock products for demonstration
    final List<Product> products = List.generate(
      10,
      (index) => Product(
        id: '${categorySlug}_$index',
        title: 'Product ${index + 1}',
        description: 'Description for product ${index + 1}',
        price: 49.99 + (index * 10),
        category: categorySlug,
        rating: 4.0 + (index % 10) * 0.1,
        reviewCount: 10 + index * 5,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(categorySlug.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter dialog
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // TODO: Show sort options
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () {
              context.push('/product/${product.id}');
            },
          );
        },
      ),
    );
  }
}