import 'package:equatable/equatable.dart';

import '../../../../core/enums/payment_methods.dart';

class PaymentOptionEntity extends Equatable {
  const PaymentOptionEntity({
    this.title = '',
    this.type = PaymentMethodType.paypal,
    this.shippingCost = 0,
  });

  final String title;
  final PaymentMethodType type;
  final double shippingCost;

  @override
  List<Object?> get props => [title, type, shippingCost];
}
