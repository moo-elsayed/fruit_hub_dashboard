import 'package:equatable/equatable.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_item_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/payment_option_entity.dart';

import '../../../../core/enums/order_status.dart';
import 'address_entity.dart';

class OrderEntity extends Equatable {
  const OrderEntity({
    this.uid = '',
    this.docId = '',
    this.orderId = 0,
    this.totalPrice = 0,
    this.products = const [],
    this.address = const AddressEntity(),
    this.paymentOption = const PaymentOptionEntity(),
    this.date = '',
    this.status = OrderStatus.pending,
  });

  final String uid;
  final String docId;
  final int orderId;
  final double totalPrice;
  final List<OrderItemEntity> products;
  final AddressEntity address;
  final PaymentOptionEntity paymentOption;
  final String date;
  final OrderStatus status;

  @override
  List<Object?> get props => [
    uid,
    docId,
    orderId,
    totalPrice,
    products,
    address,
    paymentOption,
    date,
    status,
  ];
}
