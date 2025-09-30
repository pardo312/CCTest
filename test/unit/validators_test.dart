import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_platform/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('Email Validation', () {
      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@domain.co.uk'), isNull);
      });

      test('should return error for invalid email', () {
        expect(Validators.validateEmail(''), 'Email is required');
        expect(Validators.validateEmail('test'), contains('valid email'));
        expect(Validators.validateEmail('test@'), contains('valid email'));
        expect(Validators.validateEmail('@example.com'), contains('valid email'));
      });
    });

    group('Password Validation', () {
      test('should return null for valid password', () {
        expect(Validators.validatePassword('ValidPass123!'), isNull);
        expect(Validators.validatePassword('MyP@ssw0rd'), isNull);
      });

      test('should return error for weak password', () {
        expect(Validators.validatePassword(''), 'Password is required');
        expect(Validators.validatePassword('short'), contains('8 characters'));
        expect(Validators.validatePassword('password'), contains('uppercase'));
        expect(Validators.validatePassword('PASSWORD'), contains('lowercase'));
        expect(Validators.validatePassword('Password'), contains('number'));
        expect(Validators.validatePassword('Password1'), contains('special character'));
      });
    });

    group('Name Validation', () {
      test('should return null for valid name', () {
        expect(Validators.validateName('John Doe'), isNull);
        expect(Validators.validateName("O'Connor"), isNull);
        expect(Validators.validateName('Mary-Jane'), isNull);
      });

      test('should return error for invalid name', () {
        expect(Validators.validateName(''), 'Name is required');
        expect(Validators.validateName('J'), contains('2 characters'));
        expect(Validators.validateName('John123'), contains('only contain letters'));
        expect(Validators.validateName('John@Doe'), contains('only contain letters'));
      });
    });

    group('Confirm Password Validation', () {
      test('should return null when passwords match', () {
        const password = 'TestPass123!';
        expect(
          Validators.validateConfirmPassword(password, password),
          isNull,
        );
      });

      test('should return error when passwords do not match', () {
        expect(
          Validators.validateConfirmPassword('pass1', 'pass2'),
          contains('do not match'),
        );
        expect(
          Validators.validateConfirmPassword('', 'pass'),
          contains('confirm your password'),
        );
      });
    });

    group('URL Validation', () {
      test('should return null for valid URLs', () {
        expect(Validators.validateUrl('https://example.com'), isNull);
        expect(Validators.validateUrl('http://localhost:3000'), isNull);
        expect(Validators.validateUrl(''), isNull); // Optional field
      });

      test('should return error for invalid URLs', () {
        expect(Validators.validateUrl('not-a-url'), contains('valid URL'));
        expect(Validators.validateUrl('ftp://example.com'), contains('valid URL'));
      });
    });

    group('Phone Number Validation', () {
      test('should return null for valid phone numbers', () {
        expect(Validators.validatePhoneNumber('1234567890'), isNull);
        expect(Validators.validatePhoneNumber('+1-555-123-4567'), isNull);
        expect(Validators.validatePhoneNumber(''), isNull); // Optional field
      });

      test('should return error for invalid phone numbers', () {
        expect(Validators.validatePhoneNumber('123'), contains('valid phone number'));
        expect(Validators.validatePhoneNumber('12345678901234567'), contains('valid phone number'));
      });
    });
  });
}