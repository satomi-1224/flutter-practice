import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_app/features/order/controllers/order_list_controller.dart';
import 'package:flutter_app/features/order/widgets/order_list_tile.dart';

class OrderPage extends HookConsumerWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: ordersAsync.when(
        data: (orders) => ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) => OrderListTile(order: orders[index]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
