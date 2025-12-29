import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/widgets/atoms/primary_button.dart';
import 'package:gap/gap.dart';

class CheckoutSuccessPage extends StatelessWidget {
  const CheckoutSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const Gap(24),
            const Text('Order Placed!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Gap(16),
            const Text('Thank you for your purchase.'),
            const Gap(48),
            SizedBox(
              width: 200,
              child: PrimaryButton(
                text: 'Back to Home',
                onPressed: () => context.go('/products'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
