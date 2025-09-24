import 'marketplace_config.dart';

class AppConfig {
  static const String appName = 'MarketHub';
  static const String appDescription = 'Your All-in-One Marketplace';
  static const String version = '1.0.0';

  // TODO: Replace with actual Supabase credentials
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // TODO: Replace with actual Stripe credentials
  static const String stripePublicKey = 'YOUR_STRIPE_PUBLIC_KEY';

  static const MarketplaceType primaryMarketplace = MarketplaceType.course;
  static const List<MarketplaceType> enabledMarketplaces = [
    MarketplaceType.course,
    MarketplaceType.api,
    MarketplaceType.digital,
  ];

  // Feature flags
  static const bool enableSocialLogin = true;
  static const bool enableCreditSystem = true;
  static const bool enableMultiVendor = true;
  static const bool enableReviews = true;
  static const bool enableChat = false;
  static const bool enableNotifications = true;

  // Payment configuration
  static const bool paymentTestMode = true;
  static const String defaultCurrency = 'USD';

  // API configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
}