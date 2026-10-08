import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/items/dashboard_item.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_grid_view.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_item_widget.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('DashboardGridView Widget Tests', () {
    testWidgets(
      'should render all items in the grid through DashboardItemWidget',
      (WidgetTester tester) async {
        // Arrange
        final tItems = [
          DashboardItem(
            title: 'Item 1',
            subtitle: 'Sub 1',
            icon: Icons.person,
            color: Colors.green,
            onTap: () {},
          ),
          DashboardItem(
            title: 'Item 2',
            subtitle: 'Sub 2',
            icon: Icons.shopping_bag,
            color: Colors.blue,
            onTap: () {},
          ),
          DashboardItem(
            title: 'Item 3',
            subtitle: 'Sub 3',
            icon: Icons.shopping_cart,
            color: Colors.orange,
            onTap: () {},
          ),
        ];

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: DashboardGridView(dashboardItems: tItems),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DashboardItemWidget), findsNWidgets(3));
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);
      },
    );
  });
}
