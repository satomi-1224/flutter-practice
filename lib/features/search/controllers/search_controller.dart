import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../infra/search_repository.dart';
import '../../product/models/product.dart';

part 'search_controller.g.dart';

@riverpod
class SearchController extends _$SearchController {
  @override
  FutureOr<List<Product>> build() {
    return []; // 初期状態は空
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(searchRepositoryProvider).searchProducts(query);
    });
  }
}
