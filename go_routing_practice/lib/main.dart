import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/products/presentation/bloc/product_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up all dependencies via get_it
  setupDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Get singleton AuthBloc from DI
  late final AuthBloc _authBloc = getIt<AuthBloc>();

  // Create router once (holds reference to AuthBloc for guard)
  late final _router = AppRouter.create(_authBloc);

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // AuthBloc is provided globally — used by router guard + all pages
        BlocProvider<AuthBloc>.value(value: _authBloc),

        // ProductBloc is provided globally but reset per-feature
        BlocProvider<ProductBloc>(
          create: (_) => getIt<ProductBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'GoRouter Practice',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: _router,
      ),
    );
  }
}
