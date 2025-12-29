import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/features/order/models/order.dart';
import 'package:flutter_app/features/order/infra/order_repository.dart';

part 'order_list_controller.g.dart';

@riverpod
class OrderListController extends _$OrderListController {
  @override
  FutureOr<List<Order>> build() {
    return ref.read(orderRepositoryProvider).fetchOrders();
  }
}

@riverpod
Future<Order> orderDetail(Ref ref, int id) {
  return ref.read(orderRepositoryProvider).fetchOrder(id);
}
