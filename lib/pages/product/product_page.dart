import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/features/product/controllers/product_list_controller.dart';
import 'package:flutter_app/utils/currency_formatter.dart';
import 'package:flutter_app/features/product/models/product.dart';

class ProductPage extends HookConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsAsync.when(
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductListTile(product: product);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class ProductListTile extends StatelessWidget {
  const ProductListTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          color: Colors.grey[300],
          child: const Icon(Icons.image), // Placeholder for image
        ),
        title: Text(product.title),
        subtitle: Text(CurrencyFormatter.format(product.price)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          context.go('/products/${product.id}');
        },
      ),
    );
  }
}