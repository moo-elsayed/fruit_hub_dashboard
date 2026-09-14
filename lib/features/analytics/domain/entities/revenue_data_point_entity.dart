import 'package:equatable/equatable.dart';

class RevenueDataPointEntity extends Equatable {
  const RevenueDataPointEntity({
    required this.date,
    required this.revenue,
    required this.ordersCount,
  });

  /// The start of the time bucket (day or month).
  final DateTime date;
  final double revenue;
  final int ordersCount;

  @override
  List<Object?> get props => [date, revenue, ordersCount];
}
