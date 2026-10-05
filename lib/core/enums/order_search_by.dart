import '../helpers/app_strings.dart';

enum OrderSearchBy {
  orderId,
  customerName,
  phone;

  String get label => switch (this) {
    OrderSearchBy.orderId => AppStrings.searchByOrderId,
    OrderSearchBy.customerName => AppStrings.searchByName,
    OrderSearchBy.phone => AppStrings.searchByPhone,
  };
}
