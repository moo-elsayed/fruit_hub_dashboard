import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/text_form_field_helper.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/args/product_args.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/custom_switch_container.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_form_fields.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_image_picker_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  void setPhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('ProductFormFields Widget Tests', () {
    late ProductArgs productArgs;

    setUp(() {
      productArgs = ProductArgs();
    });

    tearDown(() {
      productArgs.dispose();
    });

    Widget buildTestWidget() => createWidgetForTesting(
      child: SingleChildScrollView(
        child: ProductFormFields(productArgs: productArgs),
      ),
    );

    testWidgets(
      'should render all product form fields and switches in add mode',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange & Act
        await tester.pumpWidget(buildTestWidget());

        // Assert
        expect(find.byType(ProductImagePickerCard), findsOneWidget);
        expect(find.text(AppStrings.productName), findsOneWidget);
        expect(find.text(AppStrings.price), findsOneWidget);
        expect(find.text(AppStrings.weightInGrams), findsOneWidget);
        expect(find.text(AppStrings.productCode), findsOneWidget);
        expect(find.text(AppStrings.daysUntilExpiration), findsOneWidget);
        expect(find.text(AppStrings.numberOfCalories), findsOneWidget);
        expect(find.text(AppStrings.productDescription), findsOneWidget);
        expect(find.text(AppStrings.organic), findsOneWidget);
        expect(find.text(AppStrings.featured), findsOneWidget);

        // In add mode, code field is editable and lock icon is not present
        expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
      },
    );

    testWidgets(
      'should display lock icon and make code field read-only in edit mode',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        const tFruit = FruitEntity(
          name: 'Pineapple',
          code: 'PIN999',
          price: 55.0,
          description: 'Sweet and juicy',
          numberOfCalories: 50,
          weightInGrams: 800,
          daysUntilExpiration: 10,
          isOrganic: true,
          isFeatured: false,
        );
        productArgs.setValues(tFruit);

        // Act
        await tester.pumpWidget(buildTestWidget());

        // Assert
        expect(find.text('PIN999'), findsOneWidget);
        expect(find.text('Pineapple'), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);

        // Verify code field has readOnly set to true
        final codeFieldFinder = find.widgetWithText(
          TextFormFieldHelper,
          AppStrings.productCode,
        );
        final codeHelper = tester.widget<TextFormFieldHelper>(codeFieldFinder);
        expect(codeHelper.readOnly, isTrue);
      },
    );

    testWidgets(
      'should toggle isOrganic and isFeatured when respective switches are tapped',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        await tester.pumpWidget(buildTestWidget());

        expect(productArgs.isOrganic, isFalse);
        expect(productArgs.isFeatured, isFalse);

        // Act - Tap organic switch
        final organicSwitch = find.widgetWithText(
          CustomSwitchContainer,
          AppStrings.organic,
        );
        await tester.tap(organicSwitch);
        await tester.pumpAndSettle();

        // Assert
        expect(productArgs.isOrganic, isTrue);

        // Act - Tap featured switch
        final featuredSwitch = find.widgetWithText(
          CustomSwitchContainer,
          AppStrings.featured,
        );
        await tester.tap(featuredSwitch);
        await tester.pumpAndSettle();

        // Assert
        expect(productArgs.isFeatured, isTrue);
      },
    );

    testWidgets('should update controller text when user enters input', (
      WidgetTester tester,
    ) async {
      setPhoneViewport(tester);
      // Arrange
      await tester.pumpWidget(buildTestWidget());

      // Act
      final nameField = find.widgetWithText(
        TextFormFieldHelper,
        AppStrings.productName,
      );
      await tester.enterText(nameField, 'Fresh Orange');
      await tester.pump();

      // Assert
      expect(productArgs.nameController.text, equals('Fresh Orange'));
    });
  });
}
