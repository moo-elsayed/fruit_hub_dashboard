import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/send_notification_input_entity.dart';

class SendNotificationInputModel {
  const SendNotificationInputModel({
    required this.userId,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.type,
  });

  factory SendNotificationInputModel.fromEntity(
    SendNotificationInputEntity entity,
  ) => SendNotificationInputModel(
    userId: entity.userId,
    titleAr: entity.titleAr,
    titleEn: entity.titleEn,
    bodyAr: entity.bodyAr,
    bodyEn: entity.bodyEn,
    type: entity.type.value,
  );

  final String userId;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String type;

  Map<String, dynamic> toJson() => {
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
}
