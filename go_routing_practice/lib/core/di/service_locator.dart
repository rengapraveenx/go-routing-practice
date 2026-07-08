import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/presentation/bloc/product_bloc.dart';

/// Global service locator instance.
final getIt = GetIt.instance;

/// Registers all dependencies.
/// Call this once in [main] before [runApp].
void setupDependencies() {
  // ── Repositories ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(),
  );

  // ── BLoCs ─────────────────────────────────────────────────────────────
  // AuthBloc is a singleton so the router guard always sees current state.
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );

  // ProductBloc is a factory — a fresh instance per page.
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(productRepository: getIt<ProductRepository>()),
  );
}
