import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Cart page — demonstrates tab-level navigation preservation.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Cart')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 50,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Your cart is empty', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            const Text(
              'Browse products and add items to your cart.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Tab state concept callout
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.4)),
              ),
              child: const Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.layers_rounded,
                          color: AppColors.primary, size: 16),
                      SizedBox(width: 8),
                      Text('StatefulShellRoute',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          )),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Navigate to Products, go deep into a product, then come back here. '
                    'Your cart tab position is preserved!',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
