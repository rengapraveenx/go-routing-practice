import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class ProductsLoadRequested extends ProductEvent {
  const ProductsLoadRequested();
}

class ProductDetailRequested extends ProductEvent {
  const ProductDetailRequested({required this.id});
  final String id;
  @override
  List<Object?> get props => [id];
}
