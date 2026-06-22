abstract final class AppStrings {
  // App
  static const String appName = 'Online Shopping';

  // Screens
  static const String productsTitle = 'Products';
  static const String productDetailsTitle = 'Product Details';

  // Splash
  static const String splashTagline = 'Discover what you love';

  // Search
  static const String searchHint = 'Search products...';
  static const String allCategoryLabel = 'All';

  // Detail
  static const String descriptionLabel = 'Description';

  // Actions
  static const String retryLabel = 'Retry';

  // Empty / error states
  static const String errorTitle = 'Something went wrong';
  static const String emptyTitle = 'No products found';

  static String allProductsSeen(int count) =>
      "You've seen all $count products";
}
