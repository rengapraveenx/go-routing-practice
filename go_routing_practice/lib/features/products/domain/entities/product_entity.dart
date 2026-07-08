import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.rating,
    required this.imageEmoji,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final double rating;
  final String imageEmoji;

  @override
  List<Object?> get props => [id];
}
