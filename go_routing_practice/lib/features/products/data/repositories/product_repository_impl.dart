import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

/// Mock product data source with realistic e-commerce products.
class ProductRepositoryImpl implements ProductRepository {
  static const _products = [
    ProductEntity(
      id: '1',
      name: 'Wireless Headphones',
      description:
          'Premium noise-cancelling headphones with 30h battery life and spatial audio. '
          'Perfect for commutes and deep focus sessions.',
      price: 129.99,
      category: 'Electronics',
      rating: 4.8,
      imageEmoji: '🎧',
    ),
    ProductEntity(
      id: '2',
      name: 'Mechanical Keyboard',
      description:
          'Compact 75% layout with Cherry MX switches, per-key RGB backlighting, '
          'and a detachable USB-C cable. Built for coders.',
      price: 89.99,
      category: 'Electronics',
      rating: 4.6,
      imageEmoji: '⌨️',
    ),
    ProductEntity(
      id: '3',
      name: 'Running Shoes',
      description:
          'Lightweight mesh construction with responsive foam midsole. '
          'Designed for road running and everyday training.',
      price: 74.99,
      category: 'Sports',
      rating: 4.5,
      imageEmoji: '👟',
    ),
    ProductEntity(
      id: '4',
      name: 'Smart Watch',
      description:
          'Health monitoring with heart rate, SpO2, sleep tracking, '
          'and 7-day battery. Always-on AMOLED display.',
      price: 199.99,
      category: 'Electronics',
      rating: 4.7,
      imageEmoji: '⌚',
    ),
    ProductEntity(
      id: '5',
      name: 'Desk Lamp',
      description:
          'Adjustable LED lamp with 5 color temperatures, USB-A charging port, '
          'and touch controls. Perfect for late-night coding.',
      price: 39.99,
      category: 'Home',
      rating: 4.3,
      imageEmoji: '💡',
    ),
    ProductEntity(
      id: '6',
      name: 'Backpack Pro',
      description:
          'Water-resistant 30L backpack with dedicated laptop sleeve, '
          'hidden security pocket, and ergonomic shoulder straps.',
      price: 59.99,
      category: 'Accessories',
      rating: 4.4,
      imageEmoji: '🎒',
    ),
  ];

  @override
  Future<List<ProductEntity>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _products;
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Product not found: $id'),
    );
  }
}
