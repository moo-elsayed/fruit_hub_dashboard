import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';

class ShippingConfigModel {
  ShippingConfigModel({required this.shippingCost});

  final double shippingCost;

  factory ShippingConfigModel.fromJson(Map<String, dynamic> json) =>
      ShippingConfigModel(shippingCost: json["amount"].toDouble());

  factory ShippingConfigModel.fromEntity(ShippingConfigEntity entity) =>
      ShippingConfigModel(shippingCost: entity.shippingCost);

  Map<String, dynamic> toJson() => {"amount": shippingCost};

  ShippingConfigEntity toEntity() =>
      ShippingConfigEntity(shippingCost: shippingCost);
}
