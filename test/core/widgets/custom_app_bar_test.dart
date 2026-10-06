import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomAppBar Widget Tests', () {
    testWidgets('should render title and default properties', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const CustomAppBar(title: 'Dashboard')),
      );

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byType(CustomArrowBack), findsNothing);
    });

    testWidgets(
      'should render back arrow and trigger onTap callback when provided',
      (WidgetTester tester) async {
        // Arrange
        var backTapped = false;
        await tester.pumpWidget(
          createWidgetForTesting(
            child: CustomAppBar(
              title: 'Orders',
              showArrowBack: true,
              onTap: () => backTapped = true,
            ),
          ),
        );

        // Assert
        expect(find.byType(CustomArrowBack), findsOneWidget);

        // Act
        await tester.tap(find.byType(CustomArrowBack));
        await tester.pump();

        // Assert callback
        expect(backTapped, isTrue);
      },
    );

    testWidgets('should render actions and apply custom background color', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomAppBar(
            title: 'Settings',
            backgroundColor: Colors.blue,
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
            ],
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.settings), findsOneWidget);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(Colors.blue));
    });
  });
}
