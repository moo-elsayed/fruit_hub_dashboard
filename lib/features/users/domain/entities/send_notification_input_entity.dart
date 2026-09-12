import 'package:equatable/equatable.dart';
import 'package:fruit_hub_dashboard/core/enums/notification_type.dart';

class SendNotificationInputEntity extends Equatable {
  const SendNotificationInputEntity({
    required this.userId,
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    this.type = NotificationType.general,
  });

  final String userId;
  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final NotificationType type;

  @override
  List<Object?> get props => [userId, titleAr, titleEn, bodyAr, bodyEn, type];
}
