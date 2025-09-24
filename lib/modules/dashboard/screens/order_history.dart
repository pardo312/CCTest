import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderHistory extends ConsumerWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Mock orders
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: Text('Order #${1000 + index}'),
              subtitle: Text(
                'Date: ${DateTime.now().subtract(Duration(days: index * 7)).toString().split(' ')[0]}',
              ),
              trailing: Chip(
                label: Text(
                  index == 0 ? 'Processing' : 'Completed',
                  style: TextStyle(
                    color: index == 0 ? Colors.orange : Colors.green,
                  ),
                ),
                backgroundColor: index == 0
                    ? Colors.orange.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '\$${(99.99 + index * 50).toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Items:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(
                        2,
                        (itemIndex) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceVariant,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.shopping_bag, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text('Product ${itemIndex + 1}'),
                              ),
                              Text('\$${(49.99 + itemIndex * 10).toStringAsFixed(2)}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              // TODO: View order details
                            },
                            child: const Text('View Details'),
                          ),
                          if (index == 0)
                            TextButton(
                              onPressed: () {
                                // TODO: Track order
                              },
                              child: const Text('Track Order'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}