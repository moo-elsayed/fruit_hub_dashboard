enum UserFilterType {
  all,
  verified,
  withCart;

  String? get firestoreField => switch (this) {
    UserFilterType.all => null,
    UserFilterType.verified => 'isVerified',
    UserFilterType.withCart => 'cartItems',
  };
}
