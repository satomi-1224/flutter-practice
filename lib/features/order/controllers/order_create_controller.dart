import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_app/features/order/infra/order_repository.dart';

part 'order_create_controller.g.dart';

@riverpod
class OrderCreateController extends _$OrderCreateController {
  @override
  FutureOr<void> build() {
    // 初期状態は何もしない
  }

  Future<void> createOrder({required String itemTitle, required int totalAmount}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(orderRepositoryProvider).createOrder(itemTitle, totalAmount);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
