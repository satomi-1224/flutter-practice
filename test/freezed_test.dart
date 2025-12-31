import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_practice/features/product/models/product.dart';

void main() {
  test('Freezed model test', () {
    final product = Product(
        id: '1',
        sellerId: 's1',
        title: 't',
        description: 'd',
        price: 100,
        categoryId: 'c',
        condition: 'n',
        imageUrls: [],
        createdAt: DateTime.now());
    
    expect(product.id, '1');
  });
}
