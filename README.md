# Modular Marketplace Platform

A highly modular, configurable marketplace platform built with Flutter that enables rapid deployment of various marketplace types (online courses, digital products, APIs, services, information products) with built-in payment processing, user management, and scalable architecture.

## Features

- **Multi-marketplace support**: Courses, APIs, Digital Products, Services
- **Complete authentication system**: Login, Registration, Profile Management
- **Payment processing**: Subscription plans, One-time payments, Credit system
- **User dashboard**: Order history, Billing management, Profile settings
- **Responsive design**: Works on Web, Mobile, and Desktop
- **Modular architecture**: Easy to extend and customize

## Project Structure

```
lib/
├── config/                 # Configuration files
├── core/                   # Core functionality
│   ├── routing/           # App routing
│   ├── theme/             # Theme system
│   └── widgets/           # Shared widgets
├── modules/               # Feature modules
│   ├── auth/              # Authentication module
│   ├── dashboard/         # User dashboard
│   ├── marketplace_core/  # Core marketplace functionality
│   └── payment/           # Payment processing
└── main.dart              # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Supabase account (for backend)
- Stripe account (for payments)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate code files:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Configure Supabase and Stripe credentials in `lib/config/app_config.dart`

5. Run the app:
   ```bash
   flutter run
   ```

## Configuration

Update the configuration in `lib/config/app_config.dart`:

- Replace `YOUR_SUPABASE_URL` with your Supabase project URL
- Replace `YOUR_SUPABASE_ANON_KEY` with your Supabase anon key
- Replace `YOUR_STRIPE_PUBLIC_KEY` with your Stripe public key

## Screens Implemented

- **Home**: Marketplace home with categories and featured products
- **Product Detail**: Detailed product view
- **Category Listing**: Products filtered by category
- **Cart**: Shopping cart management
- **Login/Register**: User authentication
- **User Dashboard**: User profile and settings
- **Order History**: Past orders and tracking
- **Billing Dashboard**: Payment methods and subscription management
- **Pricing**: Subscription plans

## Next Steps

1. Set up Supabase database with the schema from MARKETPLACE_PLATFORM.md
2. Implement actual API integration with Supabase
3. Configure Stripe payment processing
4. Add specific marketplace modules (courses, APIs, etc.)
5. Implement state management with Riverpod
6. Add real-time features
7. Deploy to production

## License

This project is created as a template for building marketplace platforms.