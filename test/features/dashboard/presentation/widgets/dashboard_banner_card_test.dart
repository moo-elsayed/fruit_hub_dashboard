import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/dashboard/presentation/widgets/dashboard_banner_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('DashboardBannerCard Widget Tests', () {
    testWidgets('should render all banner texts, badges, and icon', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const DashboardBannerCard()),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.storeControlPanel), findsOneWidget);
      expect(find.text(AppStrings.welcomeToDashboard), findsOneWidget);
      expect(find.text(AppStrings.controlPanelSubtitle), findsOneWidget);
      expect(find.byIcon(Icons.dashboard_customize), findsOneWidget);
    });
  });
}
