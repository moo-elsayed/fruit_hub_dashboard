import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/theming/app_palette.dart';
import 'package:fruit_hub_dashboard/core/theming/app_text_styles.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/payment_method_stat_entity.dart';

import 'analytics_empty_state_card.dart';

class PaymentMethodsCard extends StatelessWidget {
  const PaymentMethodsCard({super.key, required this.paymentMethodStats});

  final List<PaymentMethodStatEntity> paymentMethodStats;

  @override
  Widget build(BuildContext context) {
    final totalTransactions = paymentMethodStats.fold<int>(
      0,
      (sum, s) => sum + s.count,
    );

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.paymentMethodsBreakdown,
                style: AppTextStyles.font15Bold.copyWith(
                  color: context.colors.mainText,
                ),
              ),
              Text(
                '$totalTransactions ${AppStrings.orders}',
                style: AppTextStyles.font12Medium.copyWith(
                  color: context.colors.subText,
                ),
              ),
            ],
          ),
          if (totalTransactions == 0)
            const AnalyticsEmptyStateCard()
          else
            Column(
              spacing: 14.h,
              children: paymentMethodStats.map((stat) {
                final ratio = totalTransactions > 0
                    ? stat.count / totalTransactions
                    : 0.0;
                return _PaymentMethodRow(
                  type: stat.type,
                  count: stat.count,
                  ratio: ratio,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow({
    required this.type,
    required this.count,
    required this.ratio,
  });

  final PaymentMethodType type;
  final int count;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    final color = _getMethodColor(type);
    final icon = _getMethodIcon(type);
    final percentage = (ratio * 100).toStringAsFixed(0);

    return Column(
      spacing: 6.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8.w,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 16.r, color: color),
            ),
            Expanded(
              child: Text(
                type.title,
                style: AppTextStyles.font13Medium.copyWith(
                  color: context.colors.mainText,
                ),
              ),
            ),
            Text(
              '$count ($percentage%)',
              style: AppTextStyles.font12Bold.copyWith(color: color),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6.h,
            backgroundColor: context.colors.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Color _getMethodColor(PaymentMethodType type) => switch (type) {
    PaymentMethodType.cash => AppPalette.accentGreen,
    PaymentMethodType.card => AppPalette.dashboardProducts,
    PaymentMethodType.paypal => AppPalette.dashboardAnalytics,
  };

  IconData _getMethodIcon(PaymentMethodType type) => switch (type) {
    PaymentMethodType.cash => Icons.money_rounded,
    PaymentMethodType.card => Icons.credit_card_rounded,
    PaymentMethodType.paypal => Icons.account_balance_wallet_rounded,
  };
}
