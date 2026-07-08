import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

/// Demonstrates: path params (:id), query params (?ref=), context.pop().
class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  /// Extracted from route path param: /home/products/:id
  final String productId;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(
          ProductDetailRequested(id: widget.productId),
        );
  }

  @override
  Widget build(BuildContext context) {
    // Extract optional query param: ?ref=
    final ref = GoRouterState.of(context).uri.queryParameters['ref'];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message, style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          if (state is ProductDetailLoaded) {
            return _ProductDetailView(
              product: state.product,
              refSource: ref,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({
    required this.product,
    this.refSource,
  });

  final ProductEntity product;
  final String? refSource;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Hero app bar
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              // context.pop() — goes back in the stack
              if (context.canPop()) context.pop();
            },
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.3),
                    AppColors.secondary.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  product.imageEmoji,
                  style: const TextStyle(fontSize: 90),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Source indicator (query param demo)
                if (refSource != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.secondary.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.link_rounded,
                            size: 14, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text(
                          'Arrived from: ?ref=$refSource',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Product name
                Text(product.name, style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),

                // Category + rating
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.category,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFB74D), size: 16),
                    const SizedBox(width: 4),
                    Text('${product.rating}', style: AppTextStyles.bodyMedium),
                  ],
                ),
                const SizedBox(height: 20),

                // Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),

                // Description
                const Text('About', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 8),
                Text(product.description, style: AppTextStyles.bodyLarge),
                const SizedBox(height: 24),

                // Router concept callout
                _ConceptBox(
                  title: 'Path Params + Query Params',
                  body: 'Route: /home/products/${product.id}\n'
                      'Path param: product.id = "${product.id}"\n'
                      'Query param: ?ref=${refSource ?? "(not set)"}\n\n'
                      'Extracted via:\n'
                      '• state.pathParameters[\'id\']\n'
                      '• state.uri.queryParameters[\'ref\']',
                ),
                const SizedBox(height: 32),

                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to cart!'),
                          backgroundColor: AppColors.success,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_rounded),
                    label: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ConceptBox extends StatelessWidget {
  const _ConceptBox({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code_rounded,
                  color: AppColors.secondary, size: 16),
              const SizedBox(width: 8),
              Text(title,
                  style: AppTextStyles.labelLarge
                      .copyWith(color: AppColors.secondary)),
            ],
          ),
          const SizedBox(height: 8),
          Text(body, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
