import '../../../../core/enums/order_status.dart';
import '../../domain/entities/order_status_stat_entity.dart';

class OrderStatusStatModel {
  const OrderStatusStatModel({required this.status, required this.count});

  factory OrderStatusStatModel.fromJson(Map<String, dynamic> json) =>
      OrderStatusStatModel(
        status: OrderStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => OrderStatus.pending,
        ),
        count: json['count'] as int? ?? 0,
      );

  factory OrderStatusStatModel.fromEntity(OrderStatusStatEntity entity) =>
      OrderStatusStatModel(status: entity.status, count: entity.count);

  final OrderStatus status;
  final int count;

  Map<String, dynamic> toJson() => {'status': status.name, 'count': count};

  OrderStatusStatEntity toEntity() =>
      OrderStatusStatEntity(status: status, count: count);
}
