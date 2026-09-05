import 'package:flutter/material.dart';

import '../theming/app_palette.dart';

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled;

  String get getName => switch (this) {
    OrderStatus.pending => 'Pending',
    OrderStatus.processing => 'Processing',
    OrderStatus.shipped => 'Shipped',
    OrderStatus.delivered => 'Delivered',
    OrderStatus.cancelled => 'Cancelled',
  };

  String get databaseValue => switch (this) {
    OrderStatus.pending => 'pending',
    OrderStatus.processing => 'processing',
    OrderStatus.shipped => 'shipped',
    OrderStatus.delivered => 'delivered',
    OrderStatus.cancelled => 'cancelled',
  };

  Color get color => switch (this) {
    OrderStatus.pending => AppPalette.warning,
    OrderStatus.processing => AppPalette.info,
    OrderStatus.shipped => AppPalette.secondaryOrange,
    OrderStatus.delivered => AppPalette.accentGreen,
    OrderStatus.cancelled => AppPalette.error,
  };

  Color get containerColor => color.withValues(alpha: 0.1);

  static OrderStatus fromString(String? value) => switch (value) {
    'Pending' || 'pending' => OrderStatus.pending,
    'Processing' || 'processing' => OrderStatus.processing,
    'Shipped' || 'shipped' => OrderStatus.shipped,
    'Delivered' || 'delivered' => OrderStatus.delivered,
    'Cancelled' || 'cancelled' => OrderStatus.cancelled,
    _ => OrderStatus.pending,
  };
}
