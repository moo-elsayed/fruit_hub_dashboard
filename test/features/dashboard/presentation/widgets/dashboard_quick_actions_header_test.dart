import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/extensions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_count_badge.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_quick_actions_header.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('DashboardQuickActionsHeader Widget Tests', () {
    testWidgets(
      'should render quick actions title and custom count badge with correct count',
      (WidgetTester tester) async {
        // Arrange
        late BuildContext capturedContext;

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return const DashboardQuickActionsHeader(itemCount: 5);
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.quickActions), findsOneWidget);
        expect(find.byType(CustomCountBadge), findsOneWidget);
        expect(find.text('5'), findsOneWidget);

        final titleWidget = tester.widget<Text>(
          find.text(AppStrings.quickActions),
        );
        expect(
          titleWidget.style?.color,
          equals(capturedContext.colors.mainText),
        );
      },
    );
  });
}
