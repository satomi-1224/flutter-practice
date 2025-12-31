import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

class PurchaseBottomBar extends StatelessWidget {
  const PurchaseBottomBar({super.key, required this.product});
  
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0) +
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            NumberFormat.simpleCurrency(locale: 'ja_JP').format(product.price),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: product.isSold
                ? null
                : () {
                    // TODO: Purchase flow
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text(product.isSold ? '売り切れ' : '購入手続きへ'),
          ),
        ],
      ),
    );
  }
}
