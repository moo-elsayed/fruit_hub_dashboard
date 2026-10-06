import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/edit_delete_action_buttons.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('EditDeleteActionButtons Widget Tests', () {
    testWidgets(
      'should render edit and delete icons and trigger their respective callbacks',
      (WidgetTester tester) async {
        // Arrange
        var editCalled = false;
        var deleteCalled = false;

        await tester.pumpWidget(
          createWidgetForTesting(
            child: EditDeleteActionButtons(
              onEdit: () => editCalled = true,
              onDelete: () => deleteCalled = true,
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.edit_rounded), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

        // Act: Tap edit
        await tester.tap(find.byIcon(Icons.edit_rounded));
        await tester.pump();
        expect(editCalled, isTrue);
        expect(deleteCalled, isFalse);

        // Act: Tap delete
        await tester.tap(find.byIcon(Icons.delete_outline_rounded));
        await tester.pump();
        expect(deleteCalled, isTrue);
      },
    );
  });
}
