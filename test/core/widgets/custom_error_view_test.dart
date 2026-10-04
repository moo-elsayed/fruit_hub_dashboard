import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_error_view.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_material_button.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomErrorView Widget Tests', () {
    testWidgets(
      'should render message and default icon without retry button when onRetry is null',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const CustomErrorView(message: 'Something went wrong'),
          ),
        );

        // Assert
        expect(find.text('Something went wrong'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
        expect(find.byType(CustomMaterialButton), findsNothing);
      },
    );

    testWidgets(
      'should render retry button and trigger callback when onRetry is provided',
      (WidgetTester tester) async {
        // Arrange
        var retryCalled = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomErrorView(
              message: 'Failed to load',
              onRetry: () => retryCalled = true,
            ),
          ),
        );

        // Assert initial
        expect(find.text('Failed to load'), findsOneWidget);
        expect(find.byType(CustomMaterialButton), findsOneWidget);
        expect(find.text(AppStrings.retry), findsOneWidget);

        // Act
        await tester.tap(find.byType(CustomMaterialButton));
        await tester.pump();

        // Assert callback
        expect(retryCalled, isTrue);
      },
    );

    testWidgets('should render custom icon when provided', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const CustomErrorView(
            message: 'Network disconnected',
            icon: Icons.wifi_off_rounded,
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    });
  });
}
