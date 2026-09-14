import '../../../../core/enums/payment_methods.dart';
import '../../domain/entities/payment_method_stat_entity.dart';

class PaymentMethodStatModel {
  const PaymentMethodStatModel({required this.type, required this.count});

  factory PaymentMethodStatModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodStatModel(
        type: PaymentMethodType.fromString(json['type'] as String? ?? ''),
        count: json['count'] as int? ?? 0,
      );

  factory PaymentMethodStatModel.fromEntity(PaymentMethodStatEntity entity) =>
      PaymentMethodStatModel(type: entity.type, count: entity.count);

  /// Expands the `paymentMethods` nested map from `analytics/summary`
  /// into a list of [PaymentMethodStatModel].
  /// Example: { "paypal": 5, "credit_card": 10, "cash_on_delivery": 3 }
  static List<PaymentMethodStatModel> listFromSummaryMap(
    Map<String, dynamic>? paymentMethods,
  ) {
    final map = paymentMethods ?? {};
    return PaymentMethodType.values.map((type) {
      final count = (map[type.databaseValue] as num?)?.toInt() ?? 0;
      return PaymentMethodStatModel(type: type, count: count);
    }).toList();
  }

  final PaymentMethodType type;
  final int count;

  Map<String, dynamic> toJson() => {'type': type.name, 'count': count};

  PaymentMethodStatEntity toEntity() =>
      PaymentMethodStatEntity(type: type, count: count);
}
