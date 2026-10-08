import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_kpi_section.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_skeleton_body.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/order_status_distribution_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/payment_methods_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/revenue_timeline_chart_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/top_selling_products_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('AnalyticsSkeletonBody Widget Tests', () {
    testWidgets('should render skeleton mock section cards', (tester) async {
      // Arrange
      tester.view.physicalSize = const Size(375, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const sut = AnalyticsSkeletonBody();

      // Act
      await tester.pumpWidget(createWidgetForTesting(child: sut));
      await tester.pump(const Duration(milliseconds: 100));

      // Assert
      expect(find.byType(AnalyticsSkeletonBody), findsOneWidget);
      expect(find.byType(AnalyticsKpiSection), findsOneWidget);
      expect(find.byType(RevenueTimelineChartCard), findsOneWidget);
      expect(find.byType(OrderStatusDistributionCard), findsOneWidget);
      expect(find.byType(PaymentMethodsCard), findsOneWidget);

      await tester.scrollUntilVisible(
        find.byType(TopSellingProductsCard),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byType(TopSellingProductsCard), findsOneWidget);
    });
  });
}
