import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/custom_switch_container.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomSwitchContainer Widget Tests', () {
    testWidgets(
      'should render label text and switch with initial isChecked state',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomSwitchContainer(
              text: AppStrings.organic,
              isChecked: false,
              onChanged: (_) {},
            ),
          ),
        );

        // Assert
        expect(find.text(AppStrings.organic), findsOneWidget);
        final switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isFalse);
      },
    );

    testWidgets('should render optional icon when icon is provided', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomSwitchContainer(
            text: AppStrings.organic,
            icon: Icons.eco_rounded,
            isChecked: true,
            onChanged: (_) {},
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.eco_rounded), findsOneWidget);
      expect(find.text(AppStrings.organic), findsOneWidget);
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets(
      'should toggle isChecked state and invoke onChanged callback when tapped',
      (WidgetTester tester) async {
        // Arrange
        bool? latestValue;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomSwitchContainer(
              text: AppStrings.featured,
              isChecked: false,
              onChanged: (val) => latestValue = val,
            ),
          ),
        );

        // Act - Tap to toggle on
        await tester.tap(find.byType(CustomSwitchContainer));
        await tester.pumpAndSettle();

        // Assert
        expect(latestValue, isTrue);
        var switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isTrue);

        // Act - Tap to toggle off
        await tester.tap(find.byType(CustomSwitchContainer));
        await tester.pumpAndSettle();

        // Assert
        expect(latestValue, isFalse);
        switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isFalse);
      },
    );
  });
}
