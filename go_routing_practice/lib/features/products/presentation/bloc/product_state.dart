import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductsLoaded extends ProductState {
  const ProductsLoaded({required this.products});
  final List<ProductEntity> products;
  @override
  List<Object?> get props => [products];
}

class ProductDetailLoaded extends ProductState {
  const ProductDetailLoaded({required this.product});
  final ProductEntity product;
  @override
  List<Object?> get props => [product];
}

class ProductError extends ProductState {
  const ProductError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
