/// Route path constants for the app.
/// Use these instead of raw strings when navigating.
class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';

  // Home shell
  static const home = '/home';

  // Products tab
  static const products = '/home/products';
  static const productDetail = '/home/products/:id';
  static String productDetailPath(String id) => '/home/products/$id';

  // Cart tab
  static const cart = '/home/cart';

  // Profile tab
  static const profile = '/home/profile';
  static const settings = '/home/profile/settings';

  // Error
  static const notFound = '/404';
}
