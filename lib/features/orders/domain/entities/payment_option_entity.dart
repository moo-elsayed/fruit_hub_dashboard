import '../../../../core/helpers/enums.dart';

class PaymentOptionEntity {
  const PaymentOptionEntity({
    this.title = '',
    this.type = .paypal,
    this.shippingCost = 0,
  });

  final String title;
  final PaymentMethodType type;
  final double shippingCost;
}
