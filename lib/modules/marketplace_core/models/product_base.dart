import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_base.g.dart';

@JsonSerializable()
class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final String category;
  final String? sellerId;
  final double? rating;
  final int? reviewCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool featured;
  final String status;
  final Map<String, dynamic>? metadata;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.category,
    this.sellerId,
    this.rating,
    this.reviewCount,
    this.createdAt,
    this.updatedAt,
    this.featured = false,
    this.status = 'published',
    this.metadata,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        imageUrl,
        category,
        sellerId,
        rating,
        reviewCount,
        createdAt,
        updatedAt,
        featured,
        status,
        metadata,
      ];
}