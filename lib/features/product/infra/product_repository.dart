import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_app/config/env.dart';
import 'package:flutter_app/features/product/models/product.dart';

part 'product_repository.g.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<Product> fetchProduct(int id);
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) {
  if (Env.useMock) {
    return MockProductRepository();
  }
  return ProductRepositoryImpl();
}

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<Product>> fetchProducts() async {
    // TODO: Implement actual API call using Dio
    throw UnimplementedError('Real product fetch is not implemented yet.');
  }

  @override
  Future<Product> fetchProduct(int id) async {
    // TODO: Implement actual API call using Dio
    throw UnimplementedError('Real product fetch is not implemented yet.');
  }
}

class MockProductRepository implements ProductRepository {
  final List<Product> _products = List.generate(
    20,
    (index) => Product(
      id: index + 1,
      title: 'Product ${index + 1}',
      description: 'This is a description for product ${index + 1}. It is a very cool product.',
      price: (index + 1) * 1000.0,
      imageUrl: 'https://via.placeholder.com/150',
    ),
  );

  @override
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _products;
  }

  @override
  Future<Product> fetchProduct(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _products.firstWhere((element) => element.id == id,
        orElse: () => throw Exception('Product not found'));
  }
}
