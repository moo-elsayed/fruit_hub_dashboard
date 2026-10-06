import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_filter_chip.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('SearchFilterChip Widget Tests', () {
    testWidgets('should render label and icon, and trigger onTap when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      var tapped = false;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: SearchFilterChip(
            label: 'Filter by Name',
            icon: Icons.person_rounded,
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      // Assert
      expect(find.text('Filter by Name'), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);

      // Act
      await tester.tap(find.byType(SearchFilterChip));
      await tester.pump();

      // Assert callback
      expect(tapped, isTrue);
    });

    testWidgets('should reflect selected state visual properties', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: SearchFilterChip(
            label: 'Active',
            icon: Icons.check,
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      // Assert
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = animatedContainer.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(find.text('Active'), findsOneWidget);
    });
  });
}
