abstract class BackendEndpoints {
  BackendEndpoints._();

  // Firestore Collections
  static const String productsCollection = 'products';
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';
  static const String constantsCollection = 'constants';
  static const String analyticsCollection = 'analytics';
  static const String analyticsDailyCollection = 'analytics_daily';
  static const String analyticsProductsCollection = 'products';

  // Storage
  static const String productsStorageBucket = 'products';

  // Firestore Document IDs
  static const String shippingConfigDocId = 'shipping_config';
  static const String analyticsSummaryDocId = 'summary';

  // Auth / Google Sign-In
  static const String googleServerClientId =
      '868341775085-ffcp8k56vvbbrlg5m6e5vqemdgtet5oe.apps.googleusercontent.com';
}
