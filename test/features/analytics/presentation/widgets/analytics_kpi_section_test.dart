import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/analytics_kpi_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_kpi_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_kpi_section.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('AnalyticsKpiSection Widget Tests', () {
    testWidgets(
      'should render all 4 KPI cards with formatted values and titles',
      (tester) async {
        // Arrange
        const kpi = AnalyticsKpiEntity(
          totalRevenue: 5000,
          totalOrders: 10,
          totalUsers: 80,
          verifiedUsers: 50,
          activeCartsCount: 12,
        );
        const sut = AnalyticsKpiSection(kpi: kpi);

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AnalyticsKpiCard), findsNWidgets(4));
        expect(find.text(AppStrings.totalRevenue), findsOneWidget);
        expect(find.text('5000 ${AppStrings.pounds}'), findsOneWidget);
        expect(find.text(AppStrings.totalOrders), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
        expect(find.text(AppStrings.averageOrderValue), findsOneWidget);
        expect(find.text('500.0 ${AppStrings.pounds}'), findsOneWidget);
        expect(find.text('80'), findsOneWidget);
      },
    );

    testWidgets(
      'should display 0.0 average order value when totalOrders is 0',
      (tester) async {
        // Arrange
        const kpi = AnalyticsKpiEntity(
          totalRevenue: 0,
          totalOrders: 0,
          totalUsers: 0,
          verifiedUsers: 0,
          activeCartsCount: 0,
        );
        const sut = AnalyticsKpiSection(kpi: kpi);

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('0.0 ${AppStrings.pounds}'), findsOneWidget);
      },
    );
  });
}
