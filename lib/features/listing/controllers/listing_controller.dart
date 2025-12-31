import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../product/infra/product_repository.dart';
import '../../product/models/product.dart';

part 'listing_controller.g.dart';

@riverpod
class ListingController extends _$ListingController {
  @override
  FutureOr<void> build() {
    // Initial state is void (idle)
  }

  Future<bool> submitListing({
    required String title,
    required String description,
    required int price,
    required String categoryId,
    required String condition,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newProduct = Product(
        id: const Uuid().v4(),
        sellerId: 'current_user_id', // Mock
        title: title,
        description: description,
        price: price,
        categoryId: categoryId,
        condition: condition,
        imageUrls: ['https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/400/400'], // Mock image
        createdAt: DateTime.now(),
      );

      await ref.read(productRepositoryProvider).addProduct(newProduct);
    });

    return !state.hasError;
  }
}
