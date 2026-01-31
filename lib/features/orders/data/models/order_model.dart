import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import '../../../../core/helpers/extentions.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_option_entity.dart';
import 'address_model.dart';
import 'order_item_model.dart';

class OrderModel {
  OrderModel({
    required this.uId,
    required this.docId,
    required this.orderId,
    required this.totalPrice,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.orderItems,
    required this.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> map) => OrderModel(
    uId: map['uId'] ?? '',
    docId: map['docId'] ?? '',
    orderId: map['orderId'] ?? 0,
    totalPrice: map['totalPrice'] ?? 0,
    status: map['status'] ?? '',
    paymentMethod: map['paymentMethod'] ?? '',
    shippingAddress: AddressModel.fromJson(map['shippingAddress']),
    orderItems: List<OrderItemModel>.from(
      map['orderItems']?.map((x) => OrderItemModel.fromJson(x)),
    ),
    date: map['date'] ?? '',
  );

  final String uId;
  final String docId;
  final int orderId;
  final num totalPrice;
  final String status;
  final String paymentMethod;
  final AddressModel shippingAddress;
  final List<OrderItemModel> orderItems;
  final String date;

  OrderEntity toEntity() => OrderEntity(
    uid: uId,
    docId: docId,
    orderId: orderId,
    address: shippingAddress.toEntity(),
    products: orderItems.map((e) => e.toEntity()).toList(),
    paymentOption: PaymentOptionEntity(
      type: paymentMethod == 'cash_on_delivery'
          ? PaymentMethodType.cash
          : paymentMethod == 'credit_card'
          ? PaymentMethodType.card
          : PaymentMethodType.paypal,
      shippingCost:
          totalPrice -
          orderItems.fold(0, (sum, item) => sum + (item.price * item.quantity)),
    ),
    date: date,
    status: status.toOrderStatus,
  );
}
