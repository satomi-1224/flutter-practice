import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../product/controllers/product_list_controller.dart';
import '../widgets/product_grid_view.dart';

class ProductListContainer extends HookConsumerWidget {
  const ProductListContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productListAsync = ref.watch(productListControllerProvider);

    return productListAsync.when(
      data: (products) => RefreshIndicator(
        onRefresh: () => ref.read(productListControllerProvider.notifier).refresh(),
        child: ProductGridView(products: products),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
