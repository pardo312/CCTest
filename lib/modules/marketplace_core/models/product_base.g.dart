// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String,
      sellerId: json['sellerId'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      featured: json['featured'] as bool? ?? false,
      status: json['status'] as String? ?? 'published',
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'sellerId': instance.sellerId,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'featured': instance.featured,
      'status': instance.status,
      'metadata': instance.metadata,
    };