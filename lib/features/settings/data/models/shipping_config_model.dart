import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';

class ShippingConfigModel {
  const ShippingConfigModel({
    required this.shippingCost,
    this.freeShippingThreshold = 0.0,
  });

  factory ShippingConfigModel.fromJson(Map<String, dynamic> json) =>
      ShippingConfigModel(
        shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0.0,
        freeShippingThreshold:
            (json['free_shipping_threshold'] as num?)?.toDouble() ?? 0.0,
      );

  factory ShippingConfigModel.fromEntity(ShippingConfigEntity entity) =>
      ShippingConfigModel(
        shippingCost: entity.shippingCost,
        freeShippingThreshold: entity.freeShippingThreshold,
      );

  final double shippingCost;
  final double freeShippingThreshold;

  Map<String, dynamic> toJson() => {
    'shipping_cost': shippingCost,
    'free_shipping_threshold': freeShippingThreshold,
  };

  ShippingConfigEntity toEntity() => ShippingConfigEntity(
    shippingCost: shippingCost,
    freeShippingThreshold: freeShippingThreshold,
  );
}
