import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/listing/controllers/listing_controller.dart';
import '../../features/product/controllers/product_list_controller.dart';
import '../../widgets/atoms/primary_button.dart';
import '../../widgets/molecules/app_text_field.dart';

class ListingPage extends HookConsumerWidget {
  const ListingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        final formKey = useMemoized(() => GlobalKey<FormState>());
        final titleController = useTextEditingController();
        final descController = useTextEditingController();
        final priceController = useTextEditingController();
        
        final selectedCategory = useState('cat_0');
        final selectedCondition = useState('新品、未使用');
    
        final categories = const ['レディース', 'メンズ', 'ベビー・キッズ', 'インテリア', '本・音楽・ゲーム'];
        final conditions = const ['新品、未使用', '未使用に近い', '目立った傷や汚れなし', 'やや傷や汚れあり', '傷や汚れあり', '全体的に状態が悪い'];
    
        final state = ref.watch(listingControllerProvider);
    
        Future<void> onSubmit() async {
          if (formKey.currentState!.validate()) {
            final success = await ref.read(listingControllerProvider.notifier).submitListing(
              title: titleController.text,
              description: descController.text,
              price: int.parse(priceController.text),
              categoryId: selectedCategory.value,
              condition: selectedCondition.value,
            );
    
            if (!context.mounted) return;
    
            if (success) {
              // Refresh home list
              ref.read(productListControllerProvider.notifier).refresh();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('出品しました！')),
              );
              
              // Reset form
              titleController.clear();
              descController.clear();
              priceController.clear();
              selectedCategory.value = 'cat_0';
              selectedCondition.value = '新品、未使用';
              
              // Go to Home tab (index 0)
              final shell = StatefulNavigationShell.of(context);
              shell.goBranch(0);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('出品に失敗しました')),
              );
            }
          }
        }
    

    return Scaffold(
      appBar: AppBar(title: const Text('出品')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker Placeholder
              Container(
                height: 150,
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                      Text('写真を登録', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              AppTextField(
                controller: titleController,
                label: '商品名',
                validator: (value) => value!.isEmpty ? '入力してください' : null,
              ),
              const SizedBox(height: 16),

              // Description
              AppTextField(
                controller: descController,
                label: '商品の説明',
                maxLines: 5,
                validator: (value) => value!.isEmpty ? '入力してください' : null,
              ),
              const SizedBox(height: 24),

              // Category
              DropdownButtonFormField<String>(
                initialValue: selectedCategory.value,
                decoration: const InputDecoration(
                  labelText: 'カテゴリー',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(categories.length, (index) {
                  return DropdownMenuItem(
                    value: 'cat_$index',
                    child: Text(categories[index]),
                  );
                }),
                onChanged: (value) {
                  selectedCategory.value = value!;
                },
              ),
              const SizedBox(height: 16),

              // Condition
              DropdownButtonFormField<String>(
                initialValue: selectedCondition.value,
                decoration: const InputDecoration(
                  labelText: '商品の状態',
                  border: OutlineInputBorder(),
                ),
                items: conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (value) {
                  selectedCondition.value = value!;
                },
              ),
              const SizedBox(height: 24),

              // Price
              AppTextField(
                controller: priceController,
                label: '販売価格 (¥)',
                prefixText: '¥ ',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) return '入力してください';
                  if (int.tryParse(value) == null) return '数値を入力してください';
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Submit Button
              PrimaryButton(
                text: '出品する',
                onPressed: state.isLoading ? null : onSubmit,
                isLoading: state.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}