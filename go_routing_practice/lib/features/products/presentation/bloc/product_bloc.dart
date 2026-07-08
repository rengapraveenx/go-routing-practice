import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const ProductInitial()) {
    on<ProductsLoadRequested>(_onLoadProducts);
    on<ProductDetailRequested>(_onLoadDetail);
  }

  final ProductRepository _productRepository;

  Future<void> _onLoadProducts(
    ProductsLoadRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final products = await _productRepository.getProducts();
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onLoadDetail(
    ProductDetailRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    try {
      final product = await _productRepository.getProductById(event.id);
      emit(ProductDetailLoaded(product: product));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
