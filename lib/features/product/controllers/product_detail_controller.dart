import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../infra/product_repository.dart';
import '../models/product.dart';

part 'product_detail_controller.g.dart';

@riverpod
Future<Product> productDetail(Ref ref, String id) async {
  return ref.watch(productRepositoryProvider).fetchProductDetail(id);
}