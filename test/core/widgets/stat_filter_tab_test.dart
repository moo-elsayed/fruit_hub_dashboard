import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/utils/stat_filter_tab_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_count_badge.dart';
import 'package:fruit_hub_dashboard/core/widgets/stat_filter_tab.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('StatFilterTab Widget Tests', () {
    testWidgets('should render title, icon, and count, and trigger onTap', (
      WidgetTester tester,
    ) async {
      // Arrange
      var tapped = false;
      final item = StatFilterTabItem(
        title: 'Pending',
        count: 12,
        icon: Icons.hourglass_empty_rounded,
        color: Colors.orange,
        isSelected: false,
        onTap: () => tapped = true,
      );

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(child: StatFilterTab(item: item)),
      );

      // Assert
      expect(find.text('Pending'), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_empty_rounded), findsOneWidget);
      expect(find.byType(CustomCountBadge), findsOneWidget);
      expect(find.text('12'), findsOneWidget);

      // Act: Tap
      await tester.tap(find.byType(StatFilterTab));
      await tester.pump();

      // Assert callback
      expect(tapped, isTrue);
    });

    testWidgets('should apply selected decoration when isSelected is true', (
      WidgetTester tester,
    ) async {
      // Arrange
      final item = StatFilterTabItem(
        title: 'Delivered',
        count: 45,
        icon: Icons.check_circle_rounded,
        color: Colors.green,
        isSelected: true,
        onTap: () {},
      );

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(child: StatFilterTab(item: item)),
      );

      // Assert
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = animatedContainer.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      final border = decoration!.border as Border;
      expect(border.top.color, equals(Colors.green));
    });
  });
}
