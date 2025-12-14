import 'package:fruit_hub_dashboard/core/helpers/enums.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_item_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/payment_option_entity.dart';
import 'address_entity.dart';

class OrderEntity {
  OrderEntity({
    this.uid = '',
    this.orderId = 0,
    this.products = const [],
    this.address = const AddressEntity(),
    this.paymentOption = const PaymentOptionEntity(),
    this.date = '',
    this.status = .pending,
  });

  final String uid;
  final int orderId;
  final List<OrderItemEntity> products;
  final AddressEntity address;
  final PaymentOptionEntity paymentOption;
  final String date;
  final OrderStatus status;

  double get totalPrice => products.fold(
    0,
    (previousValue, element) => previousValue + element.price,
  );
}
