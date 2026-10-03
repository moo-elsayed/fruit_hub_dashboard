import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/user_details_tab_bar.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UserDetailsTabBar Widget Tests', () {
    late TabController tabController;

    setUp(() {
      tabController = TabController(length: 3, vsync: const TestVSync());
    });

    tearDown(() {
      tabController.dispose();
    });

    testWidgets(
      'should render tabs with counts when notificationsCount is provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomScrollView(
              slivers: [
                UserDetailsTabBar(
                  tabController: tabController,
                  cartItemsCount: 3,
                  favoritesCount: 5,
                  notificationsCount: 2,
                ),
              ],
            ),
          ),
        );

        // Assert
        expect(find.text('${AppStrings.cartItems} (3)'), findsOneWidget);
        expect(find.text('${AppStrings.favorites} (5)'), findsOneWidget);
        expect(find.text('${AppStrings.notifications} (2)'), findsOneWidget);
      },
    );

    testWidgets(
      'should render notifications tab without count when notificationsCount is null',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomScrollView(
              slivers: [
                UserDetailsTabBar(
                  tabController: tabController,
                  cartItemsCount: 0,
                  favoritesCount: 0,
                  notificationsCount: null,
                ),
              ],
            ),
          ),
        );

        // Assert
        expect(find.text('${AppStrings.cartItems} (0)'), findsOneWidget);
        expect(find.text('${AppStrings.favorites} (0)'), findsOneWidget);
        expect(find.text(AppStrings.notifications), findsOneWidget);
      },
    );

    testWidgets(
      'should change tabController index when a tab is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomScrollView(
              slivers: [
                UserDetailsTabBar(
                  tabController: tabController,
                  cartItemsCount: 1,
                  favoritesCount: 2,
                  notificationsCount: 3,
                ),
              ],
            ),
          ),
        );

        // Act - Tap favorites tab
        await tester.tap(find.text('${AppStrings.favorites} (2)'));
        await tester.pumpAndSettle();

        // Assert
        expect(tabController.index, equals(1));

        // Act - Tap notifications tab
        await tester.tap(find.text('${AppStrings.notifications} (3)'));
        await tester.pumpAndSettle();

        // Assert
        expect(tabController.index, equals(2));
      },
    );
  });
}
