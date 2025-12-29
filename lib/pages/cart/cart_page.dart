import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_app/widgets/atoms/primary_button.dart';
import 'package:flutter_app/utils/currency_formatter.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final cartItems = [
      {'title': 'Product 1', 'price': 1000},
      {'title': 'Product 2', 'price': 2000},
    ];
    final total = cartItems.fold<int>(0, (sum, item) => sum + (item['price'] as int));

    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text(item['title'] as String),
                  trailing: Text(CurrencyFormatter.format(item['price'] as int)),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      CurrencyFormatter.format(total),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                PrimaryButton(
                  text: 'Checkout',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
