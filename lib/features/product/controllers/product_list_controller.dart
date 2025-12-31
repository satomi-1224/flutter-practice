import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../infra/product_repository.dart';
import '../models/product.dart';

part 'product_list_controller.g.dart';

@riverpod
class ProductListController extends _$ProductListController {
  @override
  FutureOr<List<Product>> build() async {
    return ref.watch(productRepositoryProvider).fetchProducts();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async => build());
  }
}