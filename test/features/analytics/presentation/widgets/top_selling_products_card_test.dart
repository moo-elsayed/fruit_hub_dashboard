import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/entities/top_product_entity.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_empty_state_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/leaderboard_rank_badge.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/top_selling_products_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('TopSellingProductsCard Widget Tests', () {
    testWidgets(
      'should render title and AnalyticsEmptyStateCard when topProducts is empty',
      (tester) async {
        // Arrange
        const sut = TopSellingProductsCard(topProducts: []);

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.topSellingProducts), findsOneWidget);
        expect(find.text('0 ${AppStrings.products}'), findsOneWidget);
        expect(find.byType(AnalyticsEmptyStateCard), findsOneWidget);
      },
    );

    testWidgets(
      'should render product list with rank, name, code, revenue, and sold units',
      (tester) async {
        // Arrange
        const products = [
          TopProductEntity(
            code: '101',
            name: 'مانجو كيت',
            imagePath: 'assets/images/mango.png',
            totalQuantitySold: 25,
            totalRevenue: 2500,
          ),
          TopProductEntity(
            code: '102',
            name: 'فراولة بلدي',
            imagePath: 'assets/images/strawberry.png',
            totalQuantitySold: 18,
            totalRevenue: 900,
          ),
        ];
        const sut = TopSellingProductsCard(topProducts: products);

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.topSellingProducts), findsOneWidget);
        expect(find.text('2 ${AppStrings.products}'), findsOneWidget);
        expect(find.byType(AnalyticsEmptyStateCard), findsNothing);

        // First item
        expect(find.text('مانجو كيت'), findsOneWidget);
        expect(find.text('${AppStrings.codeLabel}101'), findsOneWidget);
        expect(find.text('2500 ${AppStrings.pounds}'), findsOneWidget);
        expect(find.text('25 ${AppStrings.soldUnits}'), findsOneWidget);

        // Second item
        expect(find.text('فراولة بلدي'), findsOneWidget);
        expect(find.text('${AppStrings.codeLabel}102'), findsOneWidget);
        expect(find.text('900 ${AppStrings.pounds}'), findsOneWidget);
        expect(find.text('18 ${AppStrings.soldUnits}'), findsOneWidget);

        // Leaderboard badges
        expect(find.byType(LeaderboardRankBadge), findsNWidgets(2));
      },
    );
  });
}
