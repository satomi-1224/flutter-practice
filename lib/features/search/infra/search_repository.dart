import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../product/infra/product_repository.dart';
import '../../product/models/product.dart';

part 'search_repository.g.dart';

@riverpod
SearchRepository searchRepository(Ref ref) {
  return SearchRepository(ref);
}

class SearchRepository {
  SearchRepository(this.ref);
  final Ref ref;

  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Get all products from ProductRepository
    final allProducts = await ref.read(productRepositoryProvider).fetchProducts();
    
    if (query.isEmpty) return [];

    return allProducts.where((product) {
      return product.title.contains(query) || product.description.contains(query);
    }).toList();
  }
}