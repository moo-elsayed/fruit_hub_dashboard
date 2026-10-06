import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_text_field.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('SearchTextField Widget Tests', () {
    testWidgets('should render search icon and hint text', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const SearchTextField(hint: 'Search apples...'),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.text('Search apples...'), findsOneWidget);
    });

    testWidgets(
      'should show clear button when text is entered and clear upon tapping it',
      (WidgetTester tester) async {
        // Arrange
        final controller = TextEditingController();
        var cleared = false;
        String? changedText;

        await tester.pumpWidget(
          createWidgetForTesting(
            child: SearchTextField(
              controller: controller,
              onClear: () => cleared = true,
              onChanged: (val) => changedText = val,
            ),
          ),
        );

        // Initially no clear icon
        expect(find.byIcon(Icons.close_rounded), findsNothing);

        // Act 1: Enter text
        await tester.enterText(find.byType(TextField), 'Mango');
        await tester.pump();

        // Assert clear icon is shown
        expect(find.byIcon(Icons.close_rounded), findsOneWidget);
        expect(changedText, equals('Mango'));

        // Act 2: Tap clear button
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pump();

        // Assert text cleared and callbacks fired
        expect(controller.text, isEmpty);
        expect(cleared, isTrue);
        expect(changedText, equals(''));
        expect(find.byIcon(Icons.close_rounded), findsNothing);
      },
    );

    testWidgets('should trigger onTap callback when tapped in readOnly mode', (
      WidgetTester tester,
    ) async {
      // Arrange
      var tapped = false;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: SearchTextField(readOnly: true, onTap: () => tapped = true),
        ),
      );

      // Act
      await tester.tap(find.byType(SearchTextField));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });
  });
}
