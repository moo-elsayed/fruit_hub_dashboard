import 'package:equatable/equatable.dart';

import 'shipping_broadcast_notification_entity.dart';

class ShippingConfigEntity extends Equatable {
  const ShippingConfigEntity({
    this.shippingCost = 0.0,
    this.freeShippingThreshold = 0.0,
    this.broadcastNotification,
  });

  final double shippingCost;
  final double freeShippingThreshold;
  final ShippingBroadcastNotificationEntity? broadcastNotification;

  ShippingConfigEntity copyWith({
    double? shippingCost,
    double? freeShippingThreshold,
    ShippingBroadcastNotificationEntity? broadcastNotification,
  }) => ShippingConfigEntity(
    shippingCost: shippingCost ?? this.shippingCost,
    freeShippingThreshold: freeShippingThreshold ?? this.freeShippingThreshold,
    broadcastNotification: broadcastNotification ?? this.broadcastNotification,
  );

  @override
  List<Object?> get props => [
    shippingCost,
    freeShippingThreshold,
    broadcastNotification,
  ];
}
