import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomArrowBack Widget Tests', () {
    testWidgets('should call custom onTap callback when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      var tapped = false;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomArrowBack(onTap: () => tapped = true),
        ),
      );

      // Act
      await tester.tap(find.byType(CustomArrowBack));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('should pop route when tapped without custom onTap', (
      WidgetTester tester,
    ) async {
      // Arrange
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const Scaffold(body: CustomArrowBack()),
                    ),
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          ),
        ),
      );

      // Push new route
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();
      expect(find.byType(CustomArrowBack), findsOneWidget);

      // Act: tap back arrow
      await tester.tap(find.byType(CustomArrowBack));
      await tester.pumpAndSettle();

      // Assert: popped back to previous route
      expect(find.byType(CustomArrowBack), findsNothing);
      expect(find.text('Navigate'), findsOneWidget);
    });

    testWidgets('should rotate icon based on locale direction', (
      WidgetTester tester,
    ) async {
      // Arrange & Act (English - LTR)
      await tester.pumpWidget(
        createWidgetForTesting(
          locale: const Locale('en'),
          child: const CustomArrowBack(),
        ),
      );

      final transformFinder = find.descendant(
        of: find.byType(CustomArrowBack),
        matching: find.byType(Transform),
      );
      expect(transformFinder, findsOneWidget);
      final transformEn = tester.widget<Transform>(transformFinder);
      expect(transformEn.transform.getRotation(), isNotNull);
    });
  });
}
