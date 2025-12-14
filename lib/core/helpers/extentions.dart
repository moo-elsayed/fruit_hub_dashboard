import 'package:flutter/cupertino.dart';
import 'package:fruit_hub_dashboard/core/theming/app_colors.dart';
import 'enums.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
    required RoutePredicate predicate,
    bool rootNavigator = false,
  }) {
    return Navigator.of(
      this,
      rootNavigator: rootNavigator,
    ).pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}

extension PaymentMethodTypeExtension on PaymentMethodType {
  String get databaseValue {
    switch (this) {
      case .paypal:
        return 'paypal';
      case .card:
        return 'credit_card';
      case .cash:
        return 'cash_on_delivery';
    }
  }
}

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case .pending:
        return 'Pending';
      case .processing:
        return 'Processing';
      case .shipped:
        return 'Shipped';
      case .delivered:
        return 'Delivered';
      case .cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case .pending:
        return AppColors.orange;
      case .processing:
        return AppColors.blue;
      case .shipped:
        return AppColors.purple;
      case .delivered:
        return AppColors.green;
      case .cancelled:
        return AppColors.red;
    }
  }

  Color get containerColor => color.withValues(alpha: 0.1);
}
