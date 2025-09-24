import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/app_config.dart';
import '../widgets/product_card.dart';
import '../models/product_base.dart';

class MarketplaceHome extends ConsumerStatefulWidget {
  const MarketplaceHome({super.key});

  @override
  ConsumerState<MarketplaceHome> createState() => _MarketplaceHomeState();
}

class _MarketplaceHomeState extends ConsumerState<MarketplaceHome> {
  final List<Category> categories = [
    Category(id: '1', name: 'Courses', icon: Icons.school),
    Category(id: '2', name: 'APIs', icon: Icons.code),
    Category(id: '3', name: 'Digital Products', icon: Icons.download),
    Category(id: '4', name: 'Services', icon: Icons.build),
  ];

  final List<Product> featuredProducts = [
    Product(
      id: '1',
      title: 'Flutter Masterclass',
      description: 'Complete Flutter development course',
      price: 99.99,
      imageUrl: 'https://via.placeholder.com/300',
      category: 'Courses',
    ),
    Product(
      id: '2',
      title: 'Weather API',
      description: 'Real-time weather data API',
      price: 29.99,
      imageUrl: 'https://via.placeholder.com/300',
      category: 'APIs',
    ),
    Product(
      id: '3',
      title: 'UI Kit Pro',
      description: 'Premium Flutter UI components',
      price: 49.99,
      imageUrl: 'https://via.placeholder.com/300',
      category: 'Digital Products',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Banner
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to ${AppConfig.appName}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConfig.appDescription,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement search
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      child: const Text('Explore Marketplace'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Browse Categories',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: InkWell(
                            onTap: () {
                              context.push('/category/${category.name.toLowerCase()}');
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    category.icon,
                                    size: 40,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Featured Products Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Featured Products',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),

          // Products Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = featuredProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      context.push('/product/${product.id}');
                    },
                  );
                },
                childCount: featuredProducts.length,
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }
}

class Category {
  final String id;
  final String name;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });
}