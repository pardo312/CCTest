import 'package:flutter_test/flutter_test.dart';
import 'package:marketplace_platform/modules/marketplace_core/models/product_base.dart';

void main() {
  group('Product Model Tests', () {
    test('should create a Product with required fields', () {
      final product = Product(
        id: '1',
        title: 'Test Product',
        description: 'This is a test product',
        price: 99.99,
        category: 'Electronics',
      );

      expect(product.id, '1');
      expect(product.title, 'Test Product');
      expect(product.description, 'This is a test product');
      expect(product.price, 99.99);
      expect(product.category, 'Electronics');
      expect(product.featured, false); // Default value
      expect(product.status, 'published'); // Default value
    });

    test('should create a Product with all fields', () {
      final now = DateTime.now();
      final product = Product(
        id: '2',
        title: 'Premium Product',
        description: 'Premium test product',
        price: 199.99,
        imageUrl: 'https://example.com/image.jpg',
        category: 'Premium',
        sellerId: 'seller123',
        rating: 4.5,
        reviewCount: 10,
        createdAt: now,
        updatedAt: now,
        featured: true,
        status: 'draft',
        metadata: {'color': 'blue', 'size': 'large'},
      );

      expect(product.id, '2');
      expect(product.imageUrl, 'https://example.com/image.jpg');
      expect(product.sellerId, 'seller123');
      expect(product.rating, 4.5);
      expect(product.reviewCount, 10);
      expect(product.createdAt, now);
      expect(product.updatedAt, now);
      expect(product.featured, true);
      expect(product.status, 'draft');
      expect(product.metadata?['color'], 'blue');
      expect(product.metadata?['size'], 'large');
    });

    test('should serialize Product to JSON', () {
      final product = Product(
        id: '3',
        title: 'JSON Product',
        description: 'Product for JSON test',
        price: 49.99,
        category: 'Test',
      );

      final json = product.toJson();

      expect(json['id'], '3');
      expect(json['title'], 'JSON Product');
      expect(json['description'], 'Product for JSON test');
      expect(json['price'], 49.99);
      expect(json['category'], 'Test');
      expect(json['featured'], false);
      expect(json['status'], 'published');
    });

    test('should deserialize Product from JSON', () {
      final json = {
        'id': '4',
        'title': 'From JSON',
        'description': 'Deserialized product',
        'price': 79.99,
        'category': 'Import',
        'imageUrl': 'https://example.com/product.jpg',
        'rating': 4.2,
        'reviewCount': 5,
        'featured': true,
        'status': 'active',
      };

      final product = Product.fromJson(json);

      expect(product.id, '4');
      expect(product.title, 'From JSON');
      expect(product.description, 'Deserialized product');
      expect(product.price, 79.99);
      expect(product.category, 'Import');
      expect(product.imageUrl, 'https://example.com/product.jpg');
      expect(product.rating, 4.2);
      expect(product.reviewCount, 5);
      expect(product.featured, true);
      expect(product.status, 'active');
    });

    test('should handle equality correctly', () {
      final product1 = Product(
        id: '5',
        title: 'Product A',
        description: 'Description A',
        price: 50.00,
        category: 'Category A',
      );

      final product2 = Product(
        id: '5',
        title: 'Product A',
        description: 'Description A',
        price: 50.00,
        category: 'Category A',
      );

      final product3 = Product(
        id: '6',
        title: 'Product B',
        description: 'Description B',
        price: 60.00,
        category: 'Category B',
      );

      expect(product1, equals(product2));
      expect(product1, isNot(equals(product3)));
    });
  });
}