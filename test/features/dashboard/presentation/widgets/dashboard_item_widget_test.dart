import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/items/dashboard_item.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_item_widget.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('DashboardItemWidget Widget Tests', () {
    testWidgets(
      'should render item title, subtitle, icon, and colors correctly',
      (WidgetTester tester) async {
        // Arrange
        late BuildContext capturedContext;
        final tItem = DashboardItem(
          title: 'المنتجات',
          subtitle: 'إدارة المنتجات والمخزون',
          icon: Icons.shopping_bag_rounded,
          color: Colors.blue,
          onTap: () {},
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return DashboardItemWidget(entity: tItem);
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('المنتجات'), findsOneWidget);
        expect(find.text('إدارة المنتجات والمخزون'), findsOneWidget);

        final iconFinder = find.byIcon(Icons.shopping_bag_rounded);
        expect(iconFinder, findsOneWidget);

        final iconWidget = tester.widget<Icon>(iconFinder);
        expect(iconWidget.color, equals(Colors.blue));

        final titleWidget = tester.widget<Text>(find.text('المنتجات'));
        expect(
          titleWidget.style?.color,
          equals(capturedContext.colors.mainText),
        );

        final subtitleWidget = tester.widget<Text>(
          find.text('إدارة المنتجات والمخزون'),
        );
        expect(
          subtitleWidget.style?.color,
          equals(capturedContext.colors.subText),
        );
      },
    );

    testWidgets('should trigger onTap callback when widget is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      var wasTapped = false;
      final tItem = DashboardItem(
        title: 'المستخدمين',
        subtitle: 'إدارة المستخدمين',
        icon: Icons.people_alt_rounded,
        color: Colors.green,
        onTap: () => wasTapped = true,
      );

      await tester.pumpWidget(
        createWidgetForTesting(child: DashboardItemWidget(entity: tItem)),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(DashboardItemWidget));
      await tester.pumpAndSettle();

      // Assert
      expect(wasTapped, isTrue);
    });
  });
}
