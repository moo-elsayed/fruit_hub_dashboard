import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/user_filter_type.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_stats_header.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UsersStatsHeader Widget Tests', () {
    testWidgets(
      'should render 3 stat filter tabs with their titles, counts, and icons',
      (WidgetTester tester) async {
        // Arrange
        const totalCount = 100;
        const verifiedCount = 60;
        const activeCartCount = 25;

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: UsersStatsHeader(
              totalCount: totalCount,
              verifiedCount: verifiedCount,
              activeCartCount: activeCartCount,
              activeFilter: UserFilterType.all,
              onSelectFilter: (_) {},
            ),
          ),
        );

        // Assert
        expect(find.text(AppStrings.all), findsOneWidget);
        expect(find.text(totalCount.toString()), findsOneWidget);
        expect(find.byIcon(Icons.people_alt_rounded), findsOneWidget);

        expect(find.text(AppStrings.verifiedUsers), findsOneWidget);
        expect(find.text(verifiedCount.toString()), findsOneWidget);
        expect(find.byIcon(Icons.verified_rounded), findsOneWidget);

        expect(find.text(AppStrings.activeCarts), findsOneWidget);
        expect(find.text(activeCartCount.toString()), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart_rounded), findsOneWidget);
      },
    );

    testWidgets('should trigger onSelectFilter when verified tab is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      UserFilterType? selectedFilter;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: UsersStatsHeader(
            totalCount: 50,
            verifiedCount: 30,
            activeCartCount: 10,
            activeFilter: UserFilterType.all,
            onSelectFilter: (filter) => selectedFilter = filter,
          ),
        ),
      );

      // Act
      await tester.tap(find.text(AppStrings.verifiedUsers));
      await tester.pump();

      // Assert
      expect(selectedFilter, equals(UserFilterType.verified));
    });

    testWidgets(
      'should trigger onSelectFilter when active cart tab is tapped',
      (WidgetTester tester) async {
        // Arrange
        UserFilterType? selectedFilter;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: UsersStatsHeader(
              totalCount: 50,
              verifiedCount: 30,
              activeCartCount: 10,
              activeFilter: UserFilterType.all,
              onSelectFilter: (filter) => selectedFilter = filter,
            ),
          ),
        );

        // Act
        final activeCartFinder = find.text(AppStrings.activeCarts);
        await tester.ensureVisible(activeCartFinder);
        await tester.pumpAndSettle();
        await tester.tap(activeCartFinder);
        await tester.pump();

        // Assert
        expect(selectedFilter, equals(UserFilterType.withCart));
      },
    );

    testWidgets('should trigger onSelectFilter when all tab is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      UserFilterType? selectedFilter;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: UsersStatsHeader(
            totalCount: 50,
            verifiedCount: 30,
            activeCartCount: 10,
            activeFilter: UserFilterType.verified,
            onSelectFilter: (filter) => selectedFilter = filter,
          ),
        ),
      );

      // Act
      await tester.tap(find.text(AppStrings.all));
      await tester.pump();

      // Assert
      expect(selectedFilter, equals(UserFilterType.all));
    });
  });
}
