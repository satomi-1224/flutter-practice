import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../features/product/controllers/product_detail_controller.dart';
import '../../features/product/widgets/product_detail_body.dart';
import '../../features/product/widgets/purchase_bottom_bar.dart';

class ProductDetailPage extends HookConsumerWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return productAsync.when(
      data: (product) => Scaffold(
        body: ProductDetailBody(product: product),
        bottomNavigationBar: PurchaseBottomBar(product: product),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}