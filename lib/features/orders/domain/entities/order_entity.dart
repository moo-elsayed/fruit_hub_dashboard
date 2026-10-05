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

  OrderEntity copyWith({
    String? uid,
    String? docId,
    int? orderId,
    double? totalPrice,
    List<OrderItemEntity>? products,
    AddressEntity? address,
    PaymentOptionEntity? paymentOption,
    String? date,
    OrderStatus? status,
  }) => OrderEntity(
    uid: uid ?? this.uid,
    docId: docId ?? this.docId,
    orderId: orderId ?? this.orderId,
    totalPrice: totalPrice ?? this.totalPrice,
    products: products ?? this.products,
    address: address ?? this.address,
    paymentOption: paymentOption ?? this.paymentOption,
    date: date ?? this.date,
    status: status ?? this.status,
  );

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
