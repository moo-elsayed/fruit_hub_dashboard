import '../helpers/app_strings.dart';

enum PaymentMethodType {
  paypal,
  card,
  cash;

  String get title => switch (this) {
    PaymentMethodType.paypal => AppStrings.paypal,
    PaymentMethodType.card => AppStrings.creditCard,
    PaymentMethodType.cash => AppStrings.cashOnDelivery,
  };

  String get databaseValue => switch (this) {
    PaymentMethodType.paypal => 'paypal',
    PaymentMethodType.card => 'credit_card',
    PaymentMethodType.cash => 'cash_on_delivery',
  };

  static PaymentMethodType fromString(String? value) => switch (value) {
    'paypal' => PaymentMethodType.paypal,
    'credit_card' || 'card' => PaymentMethodType.card,
    'cash_on_delivery' || 'cash' => PaymentMethodType.cash,
    _ => PaymentMethodType.cash,
  };
}
