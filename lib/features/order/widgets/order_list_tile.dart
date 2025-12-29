import 'package:flutter/material.dart';
import 'package:flutter_app/features/order/models/order.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/utils/currency_formatter.dart';

class OrderListTile extends StatelessWidget {
  const OrderListTile({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(order.itemTitle),
      subtitle: Text(order.orderedAt.toString().split(' ')[0]),
      trailing: Text(CurrencyFormatter.format(order.totalAmount)),
      onTap: () {
        context.go('/orders/${order.id}');
      },
    );
  }
}
