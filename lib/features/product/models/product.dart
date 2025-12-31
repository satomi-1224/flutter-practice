import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String sellerId,
    required String title,
    required String description,
    required int price,
    required String categoryId,
    required String condition,
    required List<String> imageUrls,
    @Default(false) bool isSold,
    required DateTime createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}