import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';

class NotificationEntity {
  const NotificationEntity({
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

  String localizedTitle(bool isArabic) => isArabic ? titleAr : titleEn;

  String localizedBody(bool isArabic) => isArabic ? bodyAr : bodyEn;
}
