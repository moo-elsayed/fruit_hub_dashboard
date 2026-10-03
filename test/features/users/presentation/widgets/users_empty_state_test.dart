import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_empty_state.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UsersEmptyState Widget Tests', () {
    testWidgets(
      'should render icon, noUsersFound title, and subtitle correctly',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersEmptyState()),
        );

        // Assert
        expect(find.byIcon(Icons.people_outline_rounded), findsOneWidget);
        expect(find.text(AppStrings.noUsersFound), findsOneWidget);
        expect(find.text(AppStrings.noUsersSubtitle), findsOneWidget);
      },
    );
  });
}
