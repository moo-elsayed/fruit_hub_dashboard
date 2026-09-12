import 'package:equatable/equatable.dart';

import 'cart_item_entity.dart';

class DashboardUserEntity extends Equatable {
  const DashboardUserEntity({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.image = '',
    this.isVerified = false,
    this.languageCode = 'ar',
    this.fcmToken = '',
    this.lastTokenUpdate,
    this.cartItems = const [],
    this.favoriteIds = const [],
  });

  final String uid;
  final String name;
  final String email;
  final String phone;
  final String image;
  final bool isVerified;
  final String languageCode;
  final String fcmToken;
  final DateTime? lastTokenUpdate;
  final List<CartItemEntity> cartItems;
  final List<String> favoriteIds;

  int get cartCount =>
      cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
  int get favoritesCount => favoriteIds.length;
  bool get hasActiveCart => cartItems.isNotEmpty;

  DashboardUserEntity copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? image,
    bool? isVerified,
    String? languageCode,
    String? fcmToken,
    DateTime? lastTokenUpdate,
    List<CartItemEntity>? cartItems,
    List<String>? favoriteIds,
  }) => DashboardUserEntity(
    uid: uid ?? this.uid,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    image: image ?? this.image,
    isVerified: isVerified ?? this.isVerified,
    languageCode: languageCode ?? this.languageCode,
    fcmToken: fcmToken ?? this.fcmToken,
    lastTokenUpdate: lastTokenUpdate ?? this.lastTokenUpdate,
    cartItems: cartItems ?? this.cartItems,
    favoriteIds: favoriteIds ?? this.favoriteIds,
  );

  @override
  List<Object?> get props => [
    uid,
    name,
    email,
    phone,
    image,
    isVerified,
    languageCode,
    fcmToken,
    lastTokenUpdate,
    cartItems,
    favoriteIds,
  ];
}
