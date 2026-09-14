import 'package:equatable/equatable.dart';

import '../../../../core/enums/order_status.dart';

class OrderStatusStatEntity extends Equatable {
  const OrderStatusStatEntity({required this.status, required this.count});

  final OrderStatus status;
  final int count;

  @override
  List<Object?> get props => [status, count];
}
