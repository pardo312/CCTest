import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_platform/modules/auth/screens/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('should display all required form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Check for email field
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Check for login button
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);

      // Check for forgot password link
      expect(find.text('Forgot Password?'), findsOneWidget);

      // Check for sign up link
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('should validate empty email field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Find and tap the sign in button without entering any data
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.tap(signInButton);
      await tester.pump();

      // Should show validation error
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should validate invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(
        find.widgetWithType(TextFormField).first,
        'invalid-email',
      );

      // Tap sign in button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Find password field
      final passwordField = find.widgetWithType(TextFormField).last;

      // Initially password should be obscured
      final initialTextField = tester.widget<TextFormField>(passwordField);
      expect(initialTextField.obscureText, isTrue);

      // Find and tap the visibility icon
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      // Password should now be visible
      final updatedTextField = tester.widget<TextFormField>(passwordField);
      expect(updatedTextField.obscureText, isFalse);
    });

    testWidgets('should show loading indicator when signing in', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter valid credentials
      await tester.enterText(
        find.widgetWithType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithType(TextFormField).last,
        'password123',
      );

      // Tap sign in button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}