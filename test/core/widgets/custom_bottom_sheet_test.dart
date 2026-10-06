import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/utils/custom_bottom_sheet_selection_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet_handle.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomBottomSheet Widget Tests', () {
    testWidgets('should render handle, title, subtitle, and selection items', (
      WidgetTester tester,
    ) async {
      // Arrange
      final items = [
        CustomBottomSheetSelectionItem(
          title: 'Option 1',
          subtitle: 'Description 1',
          icon: Icons.check,
          isSelected: true,
          onTap: () {},
        ),
        CustomBottomSheetSelectionItem(
          title: 'Option 2',
          icon: Icons.close,
          isSelected: false,
          onTap: () {},
        ),
      ];

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: CustomBottomSheet(
            title: 'Select An Option',
            subtitle: 'Please choose one of the options below',
            items: items,
          ),
        ),
      );

      // Assert structure
      expect(find.byType(CustomBottomSheetHandle), findsOneWidget);
      expect(find.text('Select An Option'), findsOneWidget);
      expect(
        find.text('Please choose one of the options below'),
        findsOneWidget,
      );
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Description 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked_rounded), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_off_rounded), findsOneWidget);
    });

    testWidgets(
      'should dismiss bottom sheet and trigger item callback via show()',
      (WidgetTester tester) async {
        // Arrange
        var optionSelected = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    CustomBottomSheet.show(
                      context: context,
                      title: 'Actions',
                      items: [
                        CustomBottomSheetSelectionItem(
                          title: 'Do Something',
                          onTap: () => optionSelected = true,
                        ),
                      ],
                    );
                  },
                  child: const Text('Open Sheet'),
                ),
              ),
            ),
          ),
        );

        // Act 1: Open sheet
        await tester.tap(find.text('Open Sheet'));
        await tester.pumpAndSettle();

        // Assert sheet is open
        expect(find.text('Actions'), findsOneWidget);
        expect(find.text('Do Something'), findsOneWidget);

        // Act 2: Tap item
        await tester.tap(find.text('Do Something'));
        await tester.pumpAndSettle();

        // Assert callback was called and sheet closed
        expect(optionSelected, isTrue);
        expect(find.text('Actions'), findsNothing);
      },
    );
  });
}
