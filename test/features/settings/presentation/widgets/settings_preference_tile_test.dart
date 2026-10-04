import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/settings_preference_tile.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsPreferenceTile Widget Tests', () {
    testWidgets(
      'should render icon, title, trailingText, and arrow forward icon',
      (WidgetTester tester) async {
        // Arrange
        var tapped = false;

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: SettingsPreferenceTile(
              icon: Icons.language_rounded,
              title: AppStrings.language,
              trailingText: AppStrings.english,
              onTap: () => tapped = true,
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.language_rounded), findsOneWidget);
        expect(find.text(AppStrings.language), findsOneWidget);
        expect(find.text(AppStrings.english), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward_ios_rounded), findsOneWidget);
        expect(tapped, isFalse);
      },
    );

    testWidgets('should invoke onTap callback when tapped', (
      WidgetTester tester,
    ) async {
      // Arrange
      var tapped = false;
      await tester.pumpWidget(
        createWidgetForTesting(
          child: SettingsPreferenceTile(
            icon: Icons.color_lens_outlined,
            title: AppStrings.theme,
            trailingText: AppStrings.light,
            onTap: () => tapped = true,
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(SettingsPreferenceTile));
      await tester.pump();

      // Assert
      expect(tapped, isTrue);
    });
  });
}
