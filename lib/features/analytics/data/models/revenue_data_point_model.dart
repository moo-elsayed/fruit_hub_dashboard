import '../../domain/entities/revenue_data_point_entity.dart';

class RevenueDataPointModel {
  const RevenueDataPointModel({
    required this.date,
    required this.revenue,
    required this.ordersCount,
  });

  factory RevenueDataPointModel.fromJson(Map<String, dynamic> json) =>
      RevenueDataPointModel(
        date: DateTime.parse(json['date'] as String),
        revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
        ordersCount: json['ordersCount'] as int? ?? 0,
      );

  factory RevenueDataPointModel.fromEntity(RevenueDataPointEntity entity) =>
      RevenueDataPointModel(
        date: entity.date,
        revenue: entity.revenue,
        ordersCount: entity.ordersCount,
      );

  final DateTime date;
  final double revenue;
  final int ordersCount;

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'revenue': revenue,
    'ordersCount': ordersCount,
  };

  RevenueDataPointEntity toEntity() => RevenueDataPointEntity(
    date: date,
    revenue: revenue,
    ordersCount: ordersCount,
  );
}
