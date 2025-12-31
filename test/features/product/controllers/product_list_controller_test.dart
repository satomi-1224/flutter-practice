import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_practice/features/product/controllers/product_list_controller.dart';
import 'package:flutter_practice/features/product/infra/product_repository.dart';
import 'package:flutter_practice/features/product/models/product.dart';

@GenerateNiceMocks([MockSpec<ProductRepository>()])
import 'product_list_controller_test.mocks.dart';

void main() {
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
  });

  test('ProductListController returns a list of products', () async {
    // Arrange
    final products = [
      Product(
        id: '1',
        sellerId: 'user1',
        title: 'Test Product',
        description: 'Description',
        price: 1000,
        categoryId: 'cat1',
        condition: 'New',
        imageUrls: ['http://example.com/image.jpg'],
        createdAt: DateTime.now(),
      )
    ];

    when(mockRepository.fetchProducts()).thenAnswer((_) async => products);

    final container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );

    // Act & Assert
    // 初期状態はLoading
    expect(
      container.read(productListControllerProvider),
      const AsyncValue<List<Product>>.loading(),
    );

    // データ取得後
    final result = await container.read(productListControllerProvider.future);
    expect(result, products);
    verify(mockRepository.fetchProducts()).called(1);
  });
}