import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/dashboard_user_entity.dart';
import 'cart_item_model.dart';

class DashboardUserModel {
  const DashboardUserModel({
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

  factory DashboardUserModel.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    final rawLastTokenUpdate = json['lastTokenUpdate'];
    DateTime? parsedLastTokenUpdate;
    if (rawLastTokenUpdate is Timestamp) {
      parsedLastTokenUpdate = rawLastTokenUpdate.toDate();
    } else if (rawLastTokenUpdate is String) {
      parsedLastTokenUpdate = DateTime.tryParse(rawLastTokenUpdate);
    }

    final rawCartItems = json['cartItems'];
    final List<CartItemModel> cartItemsList = [];
    if (rawCartItems is List) {
      for (final item in rawCartItems) {
        if (item is Map<String, dynamic>) {
          cartItemsList.add(CartItemModel.fromJson(item));
        } else if (item is Map) {
          cartItemsList.add(
            CartItemModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    final rawFavorites = json['favoriteIds'];
    final List<String> favoritesList = [];
    if (rawFavorites is List) {
      for (final item in rawFavorites) {
        if (item != null && item.toString().isNotEmpty) {
          favoritesList.add(item.toString());
        }
      }
    }

    return DashboardUserModel(
      uid: json['uid'] ?? docId,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['phoneNumber'] ?? '',
      image: json['image'] ?? json['photoUrl'] ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
      languageCode: json['languageCode'] ?? 'ar',
      fcmToken: json['fcmToken'] ?? '',
      lastTokenUpdate: parsedLastTokenUpdate,
      cartItems: cartItemsList,
      favoriteIds: favoritesList,
    );
  }

  final String uid;
  final String name;
  final String email;
  final String phone;
  final String image;
  final bool isVerified;
  final String languageCode;
  final String fcmToken;
  final DateTime? lastTokenUpdate;
  final List<CartItemModel> cartItems;
  final List<String> favoriteIds;

  DashboardUserEntity toEntity() => DashboardUserEntity(
    uid: uid,
    name: name,
    email: email,
    phone: phone,
    image: image,
    isVerified: isVerified,
    languageCode: languageCode,
    fcmToken: fcmToken,
    lastTokenUpdate: lastTokenUpdate,
    cartItems: cartItems.map((e) => e.toEntity()).toList(),
    favoriteIds: favoriteIds,
  );
}
