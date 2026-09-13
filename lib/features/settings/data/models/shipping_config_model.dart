import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';

import 'shipping_broadcast_notification_model.dart';

class ShippingConfigModel {
  const ShippingConfigModel({
    required this.shippingCost,
    this.freeShippingThreshold = 0.0,
    this.broadcastNotification,
  });

  factory ShippingConfigModel.fromJson(Map<String, dynamic> json) =>
      ShippingConfigModel(
        shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
        freeShippingThreshold:
            (json['free_shipping_threshold'] as num?)?.toDouble() ?? 0.0,
        broadcastNotification: json['broadcast_notification'] != null
            ? ShippingBroadcastNotificationModel.fromJson(
                json['broadcast_notification'] as Map<String, dynamic>,
              )
            : null,
      );

  factory ShippingConfigModel.fromEntity(ShippingConfigEntity entity) =>
      ShippingConfigModel(
        shippingCost: entity.shippingCost,
        freeShippingThreshold: entity.freeShippingThreshold,
        broadcastNotification: entity.broadcastNotification != null
            ? ShippingBroadcastNotificationModel.fromEntity(
                entity.broadcastNotification!,
              )
            : null,
      );

  final double shippingCost;
  final double freeShippingThreshold;
  final ShippingBroadcastNotificationModel? broadcastNotification;

  Map<String, dynamic> toJson() => {
    'shipping_cost': shippingCost,
    'free_shipping_threshold': freeShippingThreshold,
    if (broadcastNotification != null && broadcastNotification!.notify)
      'broadcast_notification': broadcastNotification!.toJson(),
  };

  ShippingConfigEntity toEntity() => ShippingConfigEntity(
    shippingCost: shippingCost,
    freeShippingThreshold: freeShippingThreshold,
    broadcastNotification: broadcastNotification?.toEntity(),
  );
}
