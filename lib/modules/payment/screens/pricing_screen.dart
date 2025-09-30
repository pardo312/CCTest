import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PricingScreen extends ConsumerStatefulWidget {
  const PricingScreen({super.key});

  @override
  ConsumerState<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends ConsumerState<PricingScreen> {
  bool isMonthly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pricing Plans'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Billing Cycle Toggle
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildToggleButton(
                    'Monthly',
                    isMonthly,
                    () => setState(() => isMonthly = true),
                  ),
                  _buildToggleButton(
                    'Yearly',
                    !isMonthly,
                    () => setState(() => isMonthly = false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pricing Cards
            _buildPricingCard(
              context,
              title: 'Basic',
              price: isMonthly ? '9.99' : '99.99',
              period: isMonthly ? '/month' : '/year',
              features: [
                '10 Products',
                '100 API Calls/month',
                'Basic Support',
                '1 User',
              ],
              isPopular: false,
            ),
            const SizedBox(height: 16),
            _buildPricingCard(
              context,
              title: 'Pro',
              price: isMonthly ? '29.99' : '299.99',
              period: isMonthly ? '/month' : '/year',
              features: [
                'Unlimited Products',
                '10,000 API Calls/month',
                'Priority Support',
                '5 Users',
                'Advanced Analytics',
                'Custom Integrations',
              ],
              isPopular: true,
            ),
            const SizedBox(height: 16),
            _buildPricingCard(
              context,
              title: 'Enterprise',
              price: 'Custom',
              period: '',
              features: [
                'Everything in Pro',
                'Unlimited API Calls',
                'Dedicated Support',
                'Unlimited Users',
                'Custom Features',
                'SLA Guarantee',
              ],
              isPopular: false,
              isCustom: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPricingCard(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required bool isPopular,
    bool isCustom = false,
  }) {
    return Card(
      elevation: isPopular ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isPopular
            ? BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (isPopular) const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                if (!isCustom) Text('\$', style: Theme.of(context).textTheme.titleLarge),
                Text(
                  price,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(period, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 24),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(feature),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isCustom) {
                    // TODO: Contact sales
                  } else {
                    // TODO: Subscribe to plan
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPopular
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                child: Text(isCustom ? 'Contact Sales' : 'Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}