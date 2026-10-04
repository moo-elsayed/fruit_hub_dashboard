import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/settings_currency_field.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  group('SettingsCurrencyField Widget Tests', () {
    testWidgets('should render title, hint, and EGP suffix', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: SettingsCurrencyField(
            title: AppStrings.deliveryFees,
            controller: controller,
            hint: '50',
          ),
        ),
      );

      // Assert
      expect(find.text(AppStrings.deliveryFees), findsOneWidget);
      expect(find.text('50'), findsOneWidget);
      expect(find.text(AppStrings.egp), findsOneWidget);
    });

    testWidgets('should render subtitle when provided', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: SettingsCurrencyField(
            title: AppStrings.freeShippingThreshold,
            subtitle: AppStrings.freeShippingThresholdHelp,
            controller: controller,
          ),
        ),
      );

      // Assert
      expect(find.text(AppStrings.freeShippingThreshold), findsOneWidget);
      expect(find.text(AppStrings.freeShippingThresholdHelp), findsOneWidget);
    });

    testWidgets(
      'should show validation error when field is empty inside validated form',
      (WidgetTester tester) async {
        // Arrange
        final formKey = GlobalKey<FormState>();
        await tester.pumpWidget(
          createWidgetForTesting(
            child: Form(
              key: formKey,
              child: SettingsCurrencyField(
                title: AppStrings.deliveryFees,
                controller: controller,
              ),
            ),
          ),
        );

        // Act
        final isValid = formKey.currentState!.validate();
        await tester.pump();

        // Assert
        expect(isValid, isFalse);
        expect(find.text(AppStrings.requiredField), findsOneWidget);
      },
    );
  });
}
