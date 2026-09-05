import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';

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
    uId: map['uId']?.toString() ?? '',
    docId: map['docId']?.toString() ?? '',
    orderId: (map['orderId'] as num?)?.toInt() ?? 0,
    totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
    status: map['status']?.toString() ?? '',
    paymentMethod: map['paymentMethod']?.toString() ?? '',
    shippingAddress: map['shippingAddress'] is Map<String, dynamic>
        ? AddressModel.fromJson(map['shippingAddress'] as Map<String, dynamic>)
        : AddressModel(
            name: '',
            email: '',
            phone: '',
            city: '',
            buildingNumber: '',
            streetName: '',
            floorNumber: '',
            apartmentNumber: '',
          ),
    orderItems:
        (map['orderItems'] as List<dynamic>?)
            ?.map((x) => OrderItemModel.fromJson(x as Map<String, dynamic>))
            .toList() ??
        [],
    date: map['date']?.toString() ?? '',
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

  OrderEntity toEntity() {
    final subtotal = orderItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final shippingCost = (totalPrice > subtotal)
        ? (totalPrice - subtotal).toDouble()
        : 0.0;

    return OrderEntity(
      uid: uId,
      docId: docId,
      orderId: orderId,
      totalPrice: totalPrice.toDouble(),
      address: shippingAddress.toEntity(),
      products: orderItems.map((e) => e.toEntity()).toList(),
      paymentOption: PaymentOptionEntity(
        type: paymentMethod == 'cash_on_delivery'
            ? PaymentMethodType.cash
            : paymentMethod == 'credit_card'
            ? PaymentMethodType.card
            : PaymentMethodType.paypal,
        shippingCost: shippingCost,
      ),
      date: date,
      status: status.toOrderStatus,
    );
  }
}
