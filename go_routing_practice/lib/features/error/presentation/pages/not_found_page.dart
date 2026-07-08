import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Custom 404 / error page — triggered by errorBuilder in GoRouter.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                ).createShader(bounds),
                child: const Text(
                  '404',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Page Not Found', style: AppTextStyles.displayMedium),
              const SizedBox(height: 12),
              const Text(
                'The route you\'re looking for doesn\'t exist.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    error.toString(),
                    style:
                        AppTextStyles.caption.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.products),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
