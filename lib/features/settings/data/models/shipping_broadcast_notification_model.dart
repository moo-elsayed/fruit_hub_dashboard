import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/shipping_broadcast_notification_entity.dart';

class ShippingBroadcastNotificationModel {
  const ShippingBroadcastNotificationModel({
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    this.type = 'general',
    this.notify = true,
  });

  factory ShippingBroadcastNotificationModel.fromJson(
    Map<String, dynamic> json,
  ) => ShippingBroadcastNotificationModel(
    titleAr: json['titleAr'] as String? ?? '',
    titleEn: json['titleEn'] as String? ?? '',
    bodyAr: json['bodyAr'] as String? ?? '',
    bodyEn: json['bodyEn'] as String? ?? '',
    type: json['type'] as String? ?? 'general',
    notify: json['notify'] as bool? ?? false,
  );

  factory ShippingBroadcastNotificationModel.fromEntity(
    ShippingBroadcastNotificationEntity entity,
  ) => ShippingBroadcastNotificationModel(
    titleAr: entity.titleAr,
    titleEn: entity.titleEn,
    bodyAr: entity.bodyAr,
    bodyEn: entity.bodyEn,
    type: entity.type,
    notify: entity.notify,
  );

  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String type;
  final bool notify;

  Map<String, dynamic> toJson() => {
    'notify': notify,
    'titleAr': titleAr,
    'titleEn': titleEn,
    'bodyAr': bodyAr,
    'bodyEn': bodyEn,
    'type': type,
    'isRead': false,
    'source': 'admin_dashboard',
    'pushSent': false,
    'createdAt': FieldValue.serverTimestamp(),
  };

  ShippingBroadcastNotificationEntity toEntity() =>
      ShippingBroadcastNotificationEntity(
        titleAr: titleAr,
        titleEn: titleEn,
        bodyAr: bodyAr,
        bodyEn: bodyEn,
        type: type,
        notify: notify,
      );
}
