import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/search/controllers/search_controller.dart';
import '../../features/product/widgets/product_card.dart';
import '../../widgets/molecules/app_text_field.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchResults = ref.watch(searchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: AppTextField(
          controller: searchController,
          label: 'キーワードから探す',
          hintText: 'テレビ、スニーカーなど',
          onChanged: (value) {
            ref.read(searchControllerProvider.notifier).search(value);
          },
        ),
      ),
      body: searchResults.when(
        data: (products) {
          if (searchController.text.isEmpty) {
            return const Center(child: Text('キーワードを入力してください'));
          }
          if (products.isEmpty) {
            return const Center(child: Text('一致する商品が見つかりませんでした'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  context.push('/product/${product.id}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
