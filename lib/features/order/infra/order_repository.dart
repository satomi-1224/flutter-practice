import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_app/config/env.dart';
import 'package:flutter_app/features/order/models/order.dart';
import 'package:flutter_app/features/order/infra/order_api_client.dart';

part 'order_repository.g.dart';

abstract class OrderRepository {
  Future<List<Order>> fetchOrders();
  Future<Order> fetchOrder(int id);
  Future<void> createOrder(String itemTitle, int totalAmount);
}

@Riverpod(keepAlive: true)
OrderRepository orderRepository(Ref ref) {
  if (Env.useMock) {
    return MockOrderRepository();
  } else {
    return OrderRepositoryImpl(ref.read(orderApiClientProvider));
  }
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderApiClient _api;
  OrderRepositoryImpl(this._api);

  @override
  Future<List<Order>> fetchOrders() => _api.fetchOrders();

  @override
  Future<Order> fetchOrder(int id) => _api.fetchOrder(id);

  @override
  Future<void> createOrder(String itemTitle, int totalAmount) {
    final order = Order(
      id: 0, 
      itemTitle: itemTitle, 
      totalAmount: totalAmount, 
      orderedAt: DateTime.now()
    );
    return _api.createOrder(order);
  }
}

class MockOrderRepository implements OrderRepository {
  final List<Order> _orders = [
    Order(id: 1, itemTitle: 'Flutter Book', totalAmount: 3000, orderedAt: DateTime.now().subtract(const Duration(days: 1))),
    Order(id: 2, itemTitle: 'Dart Course', totalAmount: 5000, orderedAt: DateTime.now().subtract(const Duration(days: 3))),
  ];

  @override
  Future<List<Order>> fetchOrders() async {
    await Future.delayed(const Duration(seconds: 1));
    return _orders;
  }

  @override
  Future<Order> fetchOrder(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _orders.firstWhere((o) => o.id == id,
        orElse: () => throw Exception('Order not found'));
  }

  @override
  Future<void> createOrder(String itemTitle, int totalAmount) async {
    await Future.delayed(const Duration(seconds: 1));
    print('MOCK: Created order "$itemTitle" for $totalAmount');
  }
}
