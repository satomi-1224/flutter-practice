import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/features/products/models/product.dart';
import 'package:flutter_app/features/products/infra/product_repository.dart';

part 'product_list_controller.g.dart';

@riverpod
class ProductListController extends _$ProductListController {
  @override
  FutureOr<List<Product>> build() {
    return ref.read(productRepositoryProvider).fetchProducts();
  }
}

@riverpod
Future<Product> productDetail(Ref ref, int id) {
  return ref.read(productRepositoryProvider).fetchProduct(id);
}
