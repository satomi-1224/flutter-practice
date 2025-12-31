// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  sellerId: json['sellerId'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toInt(),
  categoryId: json['categoryId'] as String,
  condition: json['condition'] as String,
  imageUrls: (json['imageUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isSold: json['isSold'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'sellerId': instance.sellerId,
  'title': instance.title,
  'description': instance.description,
  'price': instance.price,
  'categoryId': instance.categoryId,
  'condition': instance.condition,
  'imageUrls': instance.imageUrls,
  'isSold': instance.isSold,
  'createdAt': instance.createdAt.toIso8601String(),
};
