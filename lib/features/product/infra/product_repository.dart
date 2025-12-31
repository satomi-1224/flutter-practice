import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';

part 'product_repository.g.dart';

@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) {
  return ProductRepository();
}

class ProductRepository {
  final List<Product> _mockProducts = List.generate(20, (index) {
    return Product(
      id: 'prod_$index',
      sellerId: 'user_${index % 3}',
      title: '商品タイトル $index - メルカリ風のアイテム',
      description: 'これは商品 $index の説明文です。非常に状態が良く、おすすめです。',
      price: (index + 1) * 1000,
      categoryId: 'cat_${index % 5}',
      condition: index % 2 == 0 ? '新品、未使用' : '目立った傷や汚れなし',
      imageUrls: ['https://picsum.photos/seed/${index + 100}/400/400'],
      isSold: index % 7 == 0,
      createdAt: DateTime.now().subtract(Duration(days: index)),
    );
  });

  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    return [..._mockProducts]; // Return copy
  }

  Future<Product> fetchProductDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProducts.firstWhere((p) => p.id == id);
  }

  Future<void> addProduct(Product product) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockProducts.insert(0, product);
  }
}
