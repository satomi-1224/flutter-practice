import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_app/features/order/controllers/order_list_controller.dart';
import 'package:flutter_app/utils/currency_formatter.dart';

class OrderDetailPage extends HookConsumerWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = int.tryParse(orderId);
    if (id == null) return const Scaffold(body: Center(child: Text('Invalid ID')));

    final orderAsync = ref.watch(orderDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text('Order #$orderId')),
      body: orderAsync.when(
        data: (order) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              title: const Text('Order Date'),
              trailing: Text(order.orderedAt.toString().split(' ')[0]),
            ),
            const Divider(),
            ListTile(
              title: Text(order.itemTitle),
              trailing: Text(CurrencyFormatter.format(order.totalAmount)),
            ),
            // More details...
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
