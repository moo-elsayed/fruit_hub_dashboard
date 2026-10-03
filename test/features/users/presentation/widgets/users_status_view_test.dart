import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_status_view.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UsersStatusView Widget Tests', () {
    testWidgets(
      'should render icon and message correctly with default colors',
      (WidgetTester tester) async {
        // Arrange
        const message = 'Type to search users';
        const icon = Icons.search_rounded;

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const UsersStatusView(icon: icon, message: message),
          ),
        );

        // Assert
        expect(find.byIcon(icon), findsOneWidget);
        expect(find.text(message), findsOneWidget);
        final iconWidget = tester.widget<Icon>(find.byIcon(icon));
        final textWidget = tester.widget<Text>(find.text(message));
        expect(textWidget.data, equals(message));
        expect(iconWidget.icon, equals(icon));
      },
    );

    testWidgets('should render with custom color when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      const message = 'An error occurred';
      const icon = Icons.error_outline_rounded;
      late Color errorColor;

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: Builder(
            builder: (context) {
              errorColor = context.colors.error;
              return UsersStatusView(
                icon: icon,
                message: message,
                color: errorColor,
              );
            },
          ),
        ),
      );

      // Assert
      expect(find.byIcon(icon), findsOneWidget);
      expect(find.text(message), findsOneWidget);
      final iconWidget = tester.widget<Icon>(find.byIcon(icon));
      expect(iconWidget.color, equals(errorColor));
    });
  });
}
