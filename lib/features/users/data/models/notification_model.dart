import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    required this.type,
    required this.isRead,
    this.orderId,
    this.status,
    this.productCode,
    this.createdAt,
  });

  factory NotificationModel.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    final rawCreatedAt = json['createdAt'];
    DateTime? parsedDate;
    if (rawCreatedAt is Timestamp) {
      parsedDate = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      parsedDate = DateTime.tryParse(rawCreatedAt);
    }

    final titleAr =
        json['titleAr'] as String? ?? json['title'] as String? ?? '';
    final titleEn =
        json['titleEn'] as String? ?? json['title'] as String? ?? '';
    final bodyAr = json['bodyAr'] as String? ?? json['body'] as String? ?? '';
    final bodyEn = json['bodyEn'] as String? ?? json['body'] as String? ?? '';

    return NotificationModel(
      id: docId,
      titleAr: titleAr,
      titleEn: titleEn,
      bodyAr: bodyAr,
      bodyEn: bodyEn,
      type: NotificationType.fromString(json['type'] as String?),
      isRead: json['isRead'] as bool? ?? false,
      orderId: json['orderId']?.toString(),
      status: json['status'] as String?,
      productCode: json['productCode'] as String?,
      createdAt: parsedDate,
    );
  }

  final String id;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final NotificationType type;
  final bool isRead;
  final String? orderId;
  final String? status;
  final String? productCode;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() => {
    'titleAr': titleAr,
    'titleEn': titleEn,
    'bodyAr': bodyAr,
    'bodyEn': bodyEn,
    'type': type.value,
    'isRead': isRead,
    if (orderId != null) 'orderId': orderId,
    if (status != null) 'status': status,
    if (productCode != null) 'productCode': productCode,
    if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
  };

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    titleAr: titleAr,
    titleEn: titleEn,
    bodyAr: bodyAr,
    bodyEn: bodyEn,
    type: type,
    isRead: isRead,
    orderId: orderId,
    status: status,
    productCode: productCode,
    createdAt: createdAt,
  );
}
