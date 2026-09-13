import 'package:equatable/equatable.dart';

class ShippingBroadcastNotificationEntity extends Equatable {
  const ShippingBroadcastNotificationEntity({
    required this.titleAr,
    required this.titleEn,
    required this.bodyAr,
    required this.bodyEn,
    this.type = 'general',
    this.notify = true,
  });

  final String titleAr;
  final String titleEn;
  final String bodyAr;
  final String bodyEn;
  final String type;
  final bool notify;

  @override
  List<Object?> get props => [titleAr, titleEn, bodyAr, bodyEn, type, notify];
}
