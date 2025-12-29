import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_app/features/order/controllers/order_create_controller.dart';
import 'package:flutter_app/widgets/atoms/primary_button.dart';
import 'package:flutter_app/widgets/atoms/input_field.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CheckoutPage extends HookConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final state = ref.watch(orderCreateControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Gap(16),
            InputField(
              label: 'Address',
              controller: addressController,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const Gap(32),
            const Text('Total: ¥5,000', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Gap(32),
            PrimaryButton(
              text: 'Place Order',
              isLoading: state.isLoading,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await ref.read(orderCreateControllerProvider.notifier).createOrder(
                      itemTitle: 'Sample Item Set',
                      totalAmount: 5000,
                    );
                    if (context.mounted) {
                      context.go('/checkout/success');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
