import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BillingDashboard extends ConsumerWidget {
  const BillingDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing & Payments'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current Plan Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Plan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Chip(
                        label: const Text('Active'),
                        backgroundColor: Colors.green.withOpacity(0.1),
                        labelStyle: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pro Plan',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$29.99/month',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Next billing date: ${DateTime.now().add(const Duration(days: 15)).toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          context.push('/pricing');
                        },
                        child: const Text('Change Plan'),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Cancel subscription
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Cancel Subscription'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Credit Balance Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Credit Balance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$250.00',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Add credits
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Credits'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Methods
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Methods',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // TODO: Add payment method
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.credit_card),
                  title: const Text('•••• •••• •••• 4242'),
                  subtitle: const Text('Expires 12/25'),
                  trailing: Chip(
                    label: const Text('Default'),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Billing History
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Divider(height: 0),
                ...List.generate(
                  3,
                  (index) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: index == 0
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      child: Icon(
                        index == 0 ? Icons.add : Icons.remove,
                        color: index == 0 ? Colors.green : Colors.blue,
                        size: 20,
                      ),
                    ),
                    title: Text(index == 0 ? 'Credit Purchase' : 'Subscription Payment'),
                    subtitle: Text(
                      DateTime.now().subtract(Duration(days: index * 30)).toString().split(' ')[0],
                    ),
                    trailing: Text(
                      index == 0 ? '+\$100.00' : '-\$29.99',
                      style: TextStyle(
                        color: index == 0 ? Colors.green : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: View all transactions
                      },
                      child: const Text('View All Transactions'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}