# Modular Marketplace Platform - Project Documentation

## Project Overview

A highly modular, configurable marketplace platform built with Flutter that enables rapid deployment of various marketplace types (online courses, digital products, APIs, services, information products) with built-in payment processing, user management, and scalable architecture.

## Core Architecture

### Technology Stack

#### Frontend
- **Flutter** (Web, Mobile, Desktop)
- **Riverpod** for state management
- **GoRouter** for navigation
- **Dio** for HTTP requests
- **Flutter Secure Storage** for sensitive data

#### Backend
- **Supabase**
  - PostgreSQL database
  - Row Level Security (RLS)
  - Real-time subscriptions
  - Edge Functions for serverless compute
  - Storage for file management
  - Auth for user management

#### Payment Processing
- **Stripe**
  - Subscriptions (monthly, yearly, custom)
  - One-time payments
  - Credit balance system
  - Usage-based billing
  - Payment methods management
  - Webhooks for payment events

#### Additional Services
- **Sentry** for error tracking
- **Analytics** (configurable: Mixpanel/Amplitude/PostHog)
- **CDN** for asset delivery (Cloudflare/AWS CloudFront)

## Module Structure

### Core Modules

#### 1. Auth Module (`lib/modules/auth/`)
```
auth/
├── providers/
│   ├── auth_provider.dart
│   └── session_provider.dart
├── services/
│   ├── auth_service.dart
│   └── token_manager.dart
├── models/
│   ├── user_profile.dart
│   └── auth_state.dart
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── forgot_password_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── auth_guard.dart
    └── social_login_buttons.dart
```

#### 2. Payment Module (`lib/modules/payment/`)
```
payment/
├── providers/
│   ├── payment_provider.dart
│   ├── subscription_provider.dart
│   └── credit_balance_provider.dart
├── services/
│   ├── stripe_service.dart
│   ├── subscription_manager.dart
│   └── billing_calculator.dart
├── models/
│   ├── payment_method.dart
│   ├── subscription_plan.dart
│   ├── invoice.dart
│   └── credit_transaction.dart
├── screens/
│   ├── pricing_screen.dart
│   ├── checkout_screen.dart
│   ├── billing_dashboard.dart
│   └── payment_history_screen.dart
└── widgets/
    ├── pricing_card.dart
    ├── payment_method_selector.dart
    └── subscription_status.dart
```

#### 3. Marketplace Core Module (`lib/modules/marketplace_core/`)
```
marketplace_core/
├── providers/
│   ├── product_provider.dart
│   ├── cart_provider.dart
│   └── order_provider.dart
├── services/
│   ├── product_service.dart
│   ├── search_service.dart
│   ├── recommendation_engine.dart
│   └── order_processor.dart
├── models/
│   ├── product_base.dart
│   ├── category.dart
│   ├── cart_item.dart
│   └── order.dart
├── screens/
│   ├── marketplace_home.dart
│   ├── product_listing.dart
│   ├── product_detail.dart
│   └── cart_screen.dart
└── widgets/
    ├── product_card.dart
    ├── filter_sidebar.dart
    └── search_bar.dart
```

### Marketplace Type Modules

#### 1. Course Marketplace (`lib/modules/marketplaces/course/`)
```
course/
├── models/
│   ├── course.dart
│   ├── lesson.dart
│   ├── enrollment.dart
│   └── certificate.dart
├── screens/
│   ├── course_player.dart
│   ├── course_dashboard.dart
│   └── certificate_view.dart
├── services/
│   ├── video_service.dart
│   └── progress_tracker.dart
└── widgets/
    ├── video_player.dart
    ├── lesson_list.dart
    └── progress_indicator.dart
```

#### 2. API Marketplace (`lib/modules/marketplaces/api/`)
```
api/
├── models/
│   ├── api_product.dart
│   ├── api_key.dart
│   ├── usage_metrics.dart
│   └── rate_limit.dart
├── screens/
│   ├── api_documentation.dart
│   ├── api_dashboard.dart
│   └── usage_analytics.dart
├── services/
│   ├── api_key_manager.dart
│   ├── usage_tracker.dart
│   └── rate_limiter.dart
└── widgets/
    ├── api_playground.dart
    ├── code_snippet.dart
    └── usage_chart.dart
```

#### 3. Digital Products (`lib/modules/marketplaces/digital/`)
```
digital/
├── models/
│   ├── digital_product.dart
│   ├── download_link.dart
│   └── license_key.dart
├── screens/
│   ├── download_center.dart
│   └── license_manager.dart
├── services/
│   ├── download_service.dart
│   └── license_generator.dart
└── widgets/
    ├── download_button.dart
    └── license_display.dart
```

## Database Schema

### Core Tables

```sql
-- Users (managed by Supabase Auth)
auth.users

-- Extended user profile
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id),
    username TEXT UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    seller_enabled BOOLEAN DEFAULT false,
    seller_verified BOOLEAN DEFAULT false,
    credit_balance DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Subscription plans
CREATE TABLE subscription_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    price_monthly DECIMAL(10,2),
    price_yearly DECIMAL(10,2),
    features JSONB,
    limits JSONB,
    stripe_price_id_monthly TEXT,
    stripe_price_id_yearly TEXT,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- User subscriptions
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    plan_id UUID REFERENCES subscription_plans(id),
    stripe_subscription_id TEXT UNIQUE,
    status TEXT, -- active, canceled, past_due, etc.
    current_period_start TIMESTAMP,
    current_period_end TIMESTAMP,
    cancel_at_period_end BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Credit transactions
CREATE TABLE credit_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    amount DECIMAL(10,2) NOT NULL,
    type TEXT, -- purchase, usage, refund, bonus
    description TEXT,
    reference_id TEXT,
    reference_type TEXT,
    balance_after DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Products (base table)
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id UUID REFERENCES auth.users(id),
    type TEXT NOT NULL, -- course, api, digital, service
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    short_description TEXT,
    price DECIMAL(10,2),
    pricing_model TEXT, -- one_time, subscription, usage_based
    images JSONB,
    metadata JSONB,
    status TEXT DEFAULT 'draft', -- draft, published, archived
    featured BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    published_at TIMESTAMP
);

-- Categories
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID REFERENCES categories(id),
    name TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    icon TEXT,
    marketplace_type TEXT[], -- array of marketplace types this category applies to
    sort_order INTEGER DEFAULT 0,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Product categories (many-to-many)
CREATE TABLE product_categories (
    product_id UUID REFERENCES products(id),
    category_id UUID REFERENCES categories(id),
    PRIMARY KEY (product_id, category_id)
);

-- Orders
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number TEXT UNIQUE NOT NULL,
    buyer_id UUID REFERENCES auth.users(id),
    seller_id UUID REFERENCES auth.users(id),
    status TEXT DEFAULT 'pending', -- pending, processing, completed, refunded
    subtotal DECIMAL(10,2),
    tax DECIMAL(10,2),
    total DECIMAL(10,2),
    payment_method TEXT,
    stripe_payment_intent_id TEXT,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Order items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id),
    product_id UUID REFERENCES products(id),
    quantity INTEGER DEFAULT 1,
    price DECIMAL(10,2),
    total DECIMAL(10,2),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Reviews
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID REFERENCES products(id),
    user_id UUID REFERENCES auth.users(id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    title TEXT,
    comment TEXT,
    verified_purchase BOOLEAN DEFAULT false,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

### Marketplace-Specific Tables

```sql
-- Course marketplace
CREATE TABLE courses (
    product_id UUID PRIMARY KEY REFERENCES products(id),
    duration_minutes INTEGER,
    difficulty_level TEXT,
    language TEXT,
    subtitle_languages TEXT[],
    requirements TEXT[],
    what_you_learn TEXT[],
    certificate_enabled BOOLEAN DEFAULT false,
    instructor_id UUID REFERENCES auth.users(id)
);

CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID REFERENCES courses(product_id),
    section_id UUID,
    title TEXT NOT NULL,
    description TEXT,
    video_url TEXT,
    duration_minutes INTEGER,
    attachments JSONB,
    sort_order INTEGER,
    free_preview BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID REFERENCES courses(product_id),
    user_id UUID REFERENCES auth.users(id),
    progress_percentage INTEGER DEFAULT 0,
    last_lesson_id UUID REFERENCES lessons(id),
    completed_lessons UUID[],
    certificate_issued BOOLEAN DEFAULT false,
    certificate_issued_at TIMESTAMP,
    enrolled_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP,
    UNIQUE(course_id, user_id)
);

-- API marketplace
CREATE TABLE api_products (
    product_id UUID PRIMARY KEY REFERENCES products(id),
    base_url TEXT,
    documentation_url TEXT,
    openapi_spec JSONB,
    rate_limits JSONB,
    authentication_type TEXT,
    sandbox_available BOOLEAN DEFAULT false,
    sdk_languages TEXT[]
);

CREATE TABLE api_keys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    api_product_id UUID REFERENCES api_products(product_id),
    key_hash TEXT UNIQUE NOT NULL,
    name TEXT,
    permissions JSONB,
    rate_limit_override JSONB,
    usage_limit INTEGER,
    usage_count INTEGER DEFAULT 0,
    last_used_at TIMESTAMP,
    expires_at TIMESTAMP,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE api_usage_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    api_key_id UUID REFERENCES api_keys(id),
    endpoint TEXT,
    method TEXT,
    status_code INTEGER,
    response_time_ms INTEGER,
    credits_used INTEGER DEFAULT 1,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Digital products
CREATE TABLE digital_products (
    product_id UUID PRIMARY KEY REFERENCES products(id),
    file_size_mb DECIMAL(10,2),
    file_format TEXT,
    version TEXT,
    license_type TEXT,
    system_requirements JSONB,
    download_limit INTEGER,
    updates_included BOOLEAN DEFAULT false
);

CREATE TABLE download_links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_item_id UUID REFERENCES order_items(id),
    user_id UUID REFERENCES auth.users(id),
    product_id UUID REFERENCES products(id),
    token TEXT UNIQUE NOT NULL,
    download_count INTEGER DEFAULT 0,
    max_downloads INTEGER,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);
```

## Configuration System

### Environment Configuration (`lib/config/`)

```dart
// app_config.dart
class AppConfig {
  final String appName;
  final String appDescription;
  final MarketplaceType primaryMarketplace;
  final List<MarketplaceType> enabledMarketplaces;
  final PaymentConfig paymentConfig;
  final SupabaseConfig supabaseConfig;
  final FeatureFlags features;
  final ThemeConfig theme;
  final LocalizationConfig localization;
}

// marketplace_config.dart
enum MarketplaceType {
  course,
  api,
  digital,
  service,
  information,
  subscription
}

class MarketplaceConfig {
  final MarketplaceType type;
  final bool enabled;
  final Map<String, dynamic> settings;
  final List<String> requiredModules;
  final List<String> optionalModules;
}

// payment_config.dart
class PaymentConfig {
  final String stripePublicKey;
  final bool testMode;
  final List<PaymentMethod> enabledMethods;
  final List<Currency> supportedCurrencies;
  final BillingCycle defaultBillingCycle;
  final CreditSystemConfig creditSystem;
  final TaxConfig taxConfig;
}

class CreditSystemConfig {
  final bool enabled;
  final double creditPrice;
  final Map<String, int> actionCosts;
  final bool allowNegativeBalance;
  final double minimumRecharge;
}

// feature_flags.dart
class FeatureFlags {
  final bool enableSocialLogin;
  final bool enableTwoFactor;
  final bool enableAffiliate;
  final bool enableReviews;
  final bool enableWishlist;
  final bool enableChat;
  final bool enableAnalytics;
  final bool enableNotifications;
  final bool enableMultiVendor;
  final bool enableAuction;
}
```

### Configuration Files

#### `config/app_config.json`
```json
{
  "app": {
    "name": "MarketHub",
    "description": "Your All-in-One Marketplace",
    "version": "1.0.0",
    "primaryMarketplace": "course",
    "enabledMarketplaces": ["course", "api", "digital"],
    "defaultLanguage": "en",
    "supportedLanguages": ["en", "es", "fr", "de"]
  },
  "supabase": {
    "url": "${SUPABASE_URL}",
    "anonKey": "${SUPABASE_ANON_KEY}",
    "serviceKey": "${SUPABASE_SERVICE_KEY}"
  },
  "stripe": {
    "publicKey": "${STRIPE_PUBLIC_KEY}",
    "secretKey": "${STRIPE_SECRET_KEY}",
    "webhookSecret": "${STRIPE_WEBHOOK_SECRET}",
    "testMode": true
  },
  "features": {
    "socialLogin": {
      "enabled": true,
      "providers": ["google", "github", "facebook"]
    },
    "creditSystem": {
      "enabled": true,
      "creditPrice": 1.0,
      "minimumRecharge": 10.0
    },
    "multiVendor": {
      "enabled": true,
      "commissionRate": 0.15,
      "payoutSchedule": "weekly"
    }
  },
  "billing": {
    "defaultCycle": "monthly",
    "availableCycles": ["monthly", "yearly", "lifetime"],
    "trialDays": 14,
    "gracePeriodDays": 3
  }
}
```

#### `config/marketplace_course.json`
```json
{
  "type": "course",
  "enabled": true,
  "settings": {
    "videoProviders": ["vimeo", "youtube", "bunny"],
    "maxVideoSizeMB": 5000,
    "allowDownloads": true,
    "certificateEnabled": true,
    "discussionEnabled": true,
    "assignmentsEnabled": true,
    "quizEnabled": true,
    "completionThreshold": 0.8,
    "previewLessons": 3
  },
  "categories": [
    "Programming",
    "Design",
    "Business",
    "Marketing",
    "Personal Development"
  ],
  "pricingModels": ["one-time", "subscription", "free"],
  "requiredFields": ["duration", "difficulty", "language", "requirements"],
  "searchFilters": ["category", "price", "duration", "rating", "level", "language"]
}
```

## Frontend Architecture

### State Management Pattern

```dart
// lib/core/providers/base_provider.dart
abstract class BaseNotifier<T> extends StateNotifier<AsyncValue<T>> {
  BaseNotifier() : super(const AsyncLoading());

  Future<void> load();
  Future<void> refresh();
  void setError(Object error, StackTrace stackTrace);
  void setLoading();
  void setData(T data);
}

// lib/modules/marketplace_core/providers/product_provider.dart
class ProductNotifier extends BaseNotifier<List<Product>> {
  final ProductService _productService;
  final FilterState _filters;

  @override
  Future<void> load() async {
    setLoading();
    try {
      final products = await _productService.getProducts(_filters);
      setData(products);
    } catch (e, st) {
      setError(e, st);
    }
  }

  Future<void> applyFilters(FilterState filters);
  Future<void> searchProducts(String query);
  Future<void> loadMore();
}
```

### Routing Structure

```dart
// lib/core/routing/app_router.dart
class AppRouter {
  static final router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => MarketplaceHome(),
            routes: [
              GoRoute(
                path: 'product/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ProductDetail(productId: id);
                },
              ),
              GoRoute(
                path: 'category/:slug',
                builder: (context, state) {
                  final slug = state.pathParameters['slug']!;
                  return CategoryListing(categorySlug: slug);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => UserDashboard(),
            redirect: (context, state) => authGuard(context, state),
            routes: [
              GoRoute(
                path: 'orders',
                builder: (context, state) => OrderHistory(),
              ),
              GoRoute(
                path: 'billing',
                builder: (context, state) => BillingDashboard(),
              ),
              GoRoute(
                path: 'products',
                builder: (context, state) => MyProducts(),
              ),
            ],
          ),
          GoRoute(
            path: '/seller',
            builder: (context, state) => SellerDashboard(),
            redirect: (context, state) => sellerGuard(context, state),
            routes: [
              GoRoute(
                path: 'products/new',
                builder: (context, state) => CreateProduct(),
              ),
              GoRoute(
                path: 'analytics',
                builder: (context, state) => SellerAnalytics(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(error: state.error),
  );
}
```

### Theme System

```dart
// lib/core/theme/app_theme.dart
class AppTheme {
  static ThemeData lightTheme(ColorScheme? colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme ?? ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      extensions: [
        MarketplaceThemeExtension(
          cardElevation: 2,
          borderRadius: 12,
          spacing: AppSpacing(),
        ),
      ],
    );
  }

  static ThemeData darkTheme(ColorScheme? colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme ?? ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      extensions: [
        MarketplaceThemeExtension(
          cardElevation: 4,
          borderRadius: 12,
          spacing: AppSpacing(),
        ),
      ],
    );
  }
}

// lib/core/theme/marketplace_theme_extension.dart
class MarketplaceThemeExtension extends ThemeExtension<MarketplaceThemeExtension> {
  final double cardElevation;
  final double borderRadius;
  final AppSpacing spacing;
  final MarketplaceColors marketplaceColors;
}
```

## API Structure

### Supabase Edge Functions

#### Payment Webhook Handler
```typescript
// supabase/functions/stripe-webhook/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import Stripe from "https://esm.sh/stripe@12.0.0"

serve(async (req) => {
  const signature = req.headers.get('stripe-signature')
  const body = await req.text()

  const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY'))
  const webhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET')

  try {
    const event = stripe.webhooks.constructEvent(body, signature, webhookSecret)

    switch (event.type) {
      case 'payment_intent.succeeded':
        await handlePaymentSuccess(event.data.object)
        break
      case 'customer.subscription.created':
      case 'customer.subscription.updated':
        await handleSubscriptionUpdate(event.data.object)
        break
      case 'customer.subscription.deleted':
        await handleSubscriptionCancellation(event.data.object)
        break
      case 'invoice.payment_failed':
        await handlePaymentFailure(event.data.object)
        break
    }

    return new Response(JSON.stringify({ received: true }), {
      headers: { 'Content-Type': 'application/json' },
      status: 200
    })
  } catch (err) {
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 400 }
    )
  }
})
```

#### Credit Balance Manager
```typescript
// supabase/functions/credit-balance/index.ts
import { createClient } from '@supabase/supabase-js'

export async function deductCredits(userId: string, amount: number, reason: string) {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL'),
    Deno.env.get('SUPABASE_SERVICE_KEY')
  )

  const { data: profile } = await supabase
    .from('profiles')
    .select('credit_balance')
    .eq('id', userId)
    .single()

  if (profile.credit_balance < amount) {
    throw new Error('Insufficient credits')
  }

  const newBalance = profile.credit_balance - amount

  await supabase.from('credit_transactions').insert({
    user_id: userId,
    amount: -amount,
    type: 'usage',
    description: reason,
    balance_after: newBalance
  })

  await supabase
    .from('profiles')
    .update({ credit_balance: newBalance })
    .eq('id', userId)

  return newBalance
}
```

### API Endpoints Structure

```typescript
// API Routes
GET    /api/products
GET    /api/products/:id
POST   /api/products (seller)
PUT    /api/products/:id (seller)
DELETE /api/products/:id (seller)

GET    /api/categories
GET    /api/categories/:slug/products

GET    /api/user/profile
PUT    /api/user/profile
GET    /api/user/orders
GET    /api/user/subscriptions
GET    /api/user/downloads

POST   /api/cart/add
GET    /api/cart
PUT    /api/cart/update
DELETE /api/cart/item/:id
POST   /api/cart/checkout

GET    /api/seller/dashboard
GET    /api/seller/products
GET    /api/seller/orders
GET    /api/seller/analytics
GET    /api/seller/payouts

POST   /api/payment/create-intent
POST   /api/payment/confirm
POST   /api/payment/subscribe
POST   /api/payment/cancel-subscription
POST   /api/payment/recharge-credits

GET    /api/search
GET    /api/recommendations/:userId
GET    /api/trending
```

## Module Implementation Guide

### Creating a New Marketplace Type

1. **Define the marketplace configuration**
```dart
// lib/modules/marketplaces/[type]/config/[type]_config.dart
class [Type]MarketplaceConfig extends MarketplaceConfig {
  [Type]MarketplaceConfig() : super(
    type: MarketplaceType.[type],
    enabled: true,
    settings: {
      // Specific settings
    },
    requiredModules: ['auth', 'payment', 'marketplace_core'],
    optionalModules: ['reviews', 'chat'],
  );
}
```

2. **Create the product model**
```dart
// lib/modules/marketplaces/[type]/models/[type]_product.dart
class [Type]Product extends Product {
  // Additional fields specific to this marketplace type

  [Type]Product({
    required super.id,
    required super.title,
    required super.price,
    // ... other required fields
  });
}
```

3. **Implement marketplace-specific screens**
```dart
// lib/modules/marketplaces/[type]/screens/[type]_home.dart
class [Type]MarketplaceHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MarketplaceScaffold(
      body: CustomScrollView(
        slivers: [
          [Type]Header(),
          [Type]Categories(),
          [Type]FeaturedProducts(),
          [Type]RecentProducts(),
        ],
      ),
    );
  }
}
```

4. **Register the marketplace module**
```dart
// lib/core/modules/module_registry.dart
class ModuleRegistry {
  static void registerMarketplace(MarketplaceType type) {
    switch (type) {
      case MarketplaceType.[type]:
        _modules[type] = [Type]MarketplaceModule();
        break;
    }
  }
}
```

### Adding Payment Methods

1. **Configure Stripe products**
```dart
// lib/modules/payment/config/stripe_products.dart
class StripeProducts {
  static const subscriptionPlans = {
    'basic_monthly': 'price_xxx',
    'basic_yearly': 'price_yyy',
    'pro_monthly': 'price_zzz',
    'pro_yearly': 'price_aaa',
  };

  static const creditPackages = {
    'pack_10': 'price_bbb',
    'pack_50': 'price_ccc',
    'pack_100': 'price_ddd',
  };
}
```

2. **Implement payment flow**
```dart
// lib/modules/payment/services/checkout_service.dart
class CheckoutService {
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
    Map<String, dynamic>? metadata,
  }) async {
    // Implementation
  }

  Future<Subscription> createSubscription({
    required String customerId,
    required String priceId,
    int? trialDays,
  }) async {
    // Implementation
  }

  Future<void> processCreditsRecharge({
    required String userId,
    required double amount,
    required String paymentMethodId,
  }) async {
    // Implementation
  }
}
```

## Deployment Configuration

### Docker Setup

```dockerfile
# Dockerfile
FROM flutter:3.16.0 AS builder

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build web --release

FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
```

### Environment Variables

```bash
# .env.production
SUPABASE_URL=https://[project].supabase.co
SUPABASE_ANON_KEY=[anon_key]
STRIPE_PUBLIC_KEY=pk_live_[key]
SENTRY_DSN=https://[key]@sentry.io/[project]
CDN_URL=https://cdn.example.com
ANALYTICS_KEY=[key]
```

### CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Build web
        run: flutter build web --release
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}
          STRIPE_PUBLIC_KEY: ${{ secrets.STRIPE_PUBLIC_KEY }}

      - name: Deploy to hosting
        run: |
          # Deploy to your hosting service
```

## Security Considerations

### Row Level Security (RLS) Policies

```sql
-- Products: Public read, seller write
CREATE POLICY "Products are viewable by everyone"
  ON products FOR SELECT
  USING (status = 'published');

CREATE POLICY "Sellers can manage their products"
  ON products FOR ALL
  USING (auth.uid() = seller_id);

-- Orders: Buyers and sellers can view their orders
CREATE POLICY "Users can view their orders"
  ON orders FOR SELECT
  USING (auth.uid() = buyer_id OR auth.uid() = seller_id);

-- API Keys: Users can only manage their own keys
CREATE POLICY "Users can manage their API keys"
  ON api_keys FOR ALL
  USING (auth.uid() = user_id);
```

### API Rate Limiting

```dart
// lib/core/middleware/rate_limiter.dart
class RateLimiter {
  static const limits = {
    'anonymous': RateLimit(requests: 100, window: Duration(hours: 1)),
    'authenticated': RateLimit(requests: 1000, window: Duration(hours: 1)),
    'premium': RateLimit(requests: 10000, window: Duration(hours: 1)),
  };

  static Future<bool> checkLimit(String userId, String tier) async {
    // Implementation using Redis or in-memory cache
  }
}
```

### Data Validation

```dart
// lib/core/validators/input_validator.dart
class InputValidator {
  static final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final phoneRegex = RegExp(r'^\+?1?\d{9,15}$');
  static final slugRegex = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!emailRegex.hasMatch(value)) return 'Invalid email format';
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) return 'Price is required';
    final price = double.tryParse(value);
    if (price == null || price < 0) return 'Invalid price';
    return null;
  }
}
```

## Performance Optimization

### Caching Strategy

```dart
// lib/core/cache/cache_manager.dart
class CacheManager {
  static const cacheConfig = {
    'products': CachePolicy(ttl: Duration(minutes: 5)),
    'categories': CachePolicy(ttl: Duration(hours: 24)),
    'user_profile': CachePolicy(ttl: Duration(minutes: 15)),
    'cart': CachePolicy(ttl: Duration(days: 7)),
  };

  Future<T?> get<T>(String key) async {
    // Check memory cache first
    // Then check persistent cache
    // Return null if not found or expired
  }

  Future<void> set<T>(String key, T value, {Duration? ttl}) async {
    // Store in both memory and persistent cache
  }
}
```

### Image Optimization

```dart
// lib/core/services/image_service.dart
class ImageService {
  static String getOptimizedUrl(String originalUrl, {
    int? width,
    int? height,
    int quality = 85,
    String format = 'webp',
  }) {
    // Return CDN URL with transformation parameters
    return '${CDN_URL}/transform?url=$originalUrl&w=$width&h=$height&q=$quality&f=$format';
  }

  static Future<void> uploadProductImages(List<File> images) async {
    // Compress images before upload
    // Generate multiple sizes (thumbnail, medium, large)
    // Upload to Supabase Storage
  }
}
```

### Lazy Loading

```dart
// lib/core/widgets/lazy_load_list.dart
class LazyLoadList<T> extends StatefulWidget {
  final Future<List<T>> Function(int page, int limit) loadMore;
  final Widget Function(BuildContext, T) itemBuilder;
  final int pageSize;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= items.length) {
                _loadNextPage();
                return LoadingIndicator();
              }
              return itemBuilder(context, items[index]);
            },
          ),
        ),
      ],
    );
  }
}
```

## Monitoring & Analytics

### Error Tracking

```dart
// lib/core/services/error_service.dart
class ErrorService {
  static Future<void> initialize() async {
    await SentryFlutter.init(
      (options) {
        options.dsn = SENTRY_DSN;
        options.tracesSampleRate = 0.3;
        options.environment = kReleaseMode ? 'production' : 'development';
      },
    );

    FlutterError.onError = (details) {
      Sentry.captureException(
        details.exception,
        stackTrace: details.stack,
      );
    };
  }

  static void logError(dynamic error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) {
        extra?.forEach((key, value) {
          scope.setExtra(key, value);
        });
      },
    );
  }
}
```

### Analytics Events

```dart
// lib/core/analytics/analytics_service.dart
class AnalyticsService {
  static void trackEvent(String eventName, [Map<String, dynamic>? properties]) {
    // Send to analytics provider (Mixpanel, Amplitude, etc.)
  }

  static void trackProductView(Product product) {
    trackEvent('product_viewed', {
      'product_id': product.id,
      'product_name': product.title,
      'category': product.category,
      'price': product.price,
    });
  }

  static void trackPurchase(Order order) {
    trackEvent('purchase_completed', {
      'order_id': order.id,
      'total': order.total,
      'items_count': order.items.length,
      'payment_method': order.paymentMethod,
    });
  }
}
```

## Testing Strategy

### Unit Tests

```dart
// test/modules/payment/services/stripe_service_test.dart
void main() {
  group('StripeService', () {
    late StripeService stripeService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      stripeService = StripeService(client: mockHttpClient);
    });

    test('creates payment intent successfully', () async {
      when(mockHttpClient.post(any, body: anyNamed('body')))
        .thenAnswer((_) async => Response('{"id": "pi_test"}', 200));

      final intent = await stripeService.createPaymentIntent(
        amount: 1000,
        currency: 'usd',
      );

      expect(intent.id, equals('pi_test'));
    });
  });
}
```

### Integration Tests

```dart
// integration_test/checkout_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete checkout flow', (tester) async {
    await tester.pumpWidget(MyApp());

    // Navigate to product
    await tester.tap(find.text('Browse Products'));
    await tester.pumpAndSettle();

    // Add to cart
    await tester.tap(find.byIcon(Icons.add_shopping_cart).first);
    await tester.pumpAndSettle();

    // Go to cart
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    // Proceed to checkout
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    // Fill payment details
    await tester.enterText(find.byKey(Key('card_number')), '4242424242424242');
    await tester.enterText(find.byKey(Key('card_expiry')), '12/25');
    await tester.enterText(find.byKey(Key('card_cvc')), '123');

    // Complete purchase
    await tester.tap(find.text('Pay Now'));
    await tester.pumpAndSettle();

    // Verify success
    expect(find.text('Order Confirmed'), findsOneWidget);
  });
}
```

## Quick Start Guide

### 1. Clone and Configure

```bash
git clone [repository]
cd marketplace-platform
cp config/app_config.example.json config/app_config.json
cp .env.example .env
```

### 2. Set Up Supabase

```bash
# Install Supabase CLI
npm install -g supabase

# Initialize Supabase
supabase init

# Link to your project
supabase link --project-ref [project-ref]

# Run migrations
supabase db push

# Deploy Edge Functions
supabase functions deploy
```

### 3. Configure Stripe

1. Create Stripe account
2. Set up products and prices in Stripe Dashboard
3. Configure webhooks endpoint
4. Add keys to .env file

### 4. Install Dependencies

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run Development Server

```bash
flutter run -d chrome --dart-define-from-file=config/dev.json
```

### 6. Deploy

```bash
# Build for web
flutter build web --release

# Deploy to hosting
firebase deploy --only hosting

# Or use Docker
docker build -t marketplace-app .
docker run -p 8080:80 marketplace-app
```

## Maintenance & Updates

### Regular Tasks

- **Daily**: Monitor error logs, check payment webhook failures
- **Weekly**: Review analytics, update product recommendations
- **Monthly**: Security updates, dependency updates, performance review
- **Quarterly**: Feature review, user feedback implementation

### Scaling Considerations

1. **Database Optimization**
   - Implement database indexing
   - Use materialized views for complex queries
   - Consider read replicas for high traffic

2. **Caching Layer**
   - Implement Redis for session management
   - Use CDN for static assets
   - Cache API responses

3. **Microservices Migration**
   - Extract payment processing to separate service
   - Separate search functionality
   - Independent recommendation engine

## Support & Resources

- **Documentation**: [Internal Wiki URL]
- **API Reference**: [API Docs URL]
- **Design System**: [Figma/Storybook URL]
- **Support Channel**: [Slack/Discord Channel]
- **Issue Tracking**: [GitHub/Jira URL]

## License & Legal

- Ensure compliance with marketplace regulations
- Implement proper data protection (GDPR, CCPA)
- Include terms of service and privacy policy
- Set up proper SSL certificates
- Implement PCI compliance for payment processing