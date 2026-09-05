import 'package:equatable/equatable.dart';

class ShippingConfigEntity extends Equatable {
  const ShippingConfigEntity({
    this.shippingCost = 0.0,
    this.freeShippingThreshold = 0.0,
  });

  final double shippingCost;
  final double freeShippingThreshold;

  ShippingConfigEntity copyWith({
    double? shippingCost,
    double? freeShippingThreshold,
  }) => ShippingConfigEntity(
    shippingCost: shippingCost ?? this.shippingCost,
    freeShippingThreshold: freeShippingThreshold ?? this.freeShippingThreshold,
  );

  @override
  List<Object?> get props => [shippingCost, freeShippingThreshold];
}
