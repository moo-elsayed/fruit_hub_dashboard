import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_action_button.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_image_picker_card.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_image_picker_empty_card.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/widgets/product_image_picker_filled_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  void setPhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  group('ProductImagePickerCard Widget Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets(
      'should render ProductImagePickerEmptyCard when controller text is empty',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: ProductImagePickerCard(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(ProductImagePickerEmptyCard), findsOneWidget);
        expect(find.byType(ProductImagePickerFilledCard), findsNothing);
        expect(find.text(AppStrings.productImage), findsOneWidget);
        expect(find.text(AppStrings.pleaseSelectImage), findsOneWidget);
        expect(find.byIcon(Icons.add_photo_alternate_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'should render ProductImagePickerFilledCard when controller has an image path',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        controller.text = 'https://example.com/fruit.png';

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: ProductImagePickerCard(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(ProductImagePickerFilledCard), findsOneWidget);
        expect(find.byType(ProductImagePickerEmptyCard), findsNothing);
        expect(find.byIcon(Icons.camera_alt_rounded), findsOneWidget);
        expect(find.byType(ProductActionButton), findsNWidgets(2));
      },
    );

    testWidgets(
      'should clear controller and switch to empty card when delete button is tapped',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        controller.text = 'https://example.com/fruit.png';
        await tester.pumpWidget(
          createWidgetForTesting(
            child: ProductImagePickerCard(controller: controller),
          ),
        );

        // Assert initially filled
        expect(find.byType(ProductImagePickerFilledCard), findsOneWidget);

        // Act - Tap delete button
        final deleteButtonFinder = find.byWidgetPredicate(
          (w) =>
              w is ProductActionButton &&
              w.icon == Icons.delete_outline_rounded,
        );
        await tester.tap(deleteButtonFinder);
        await tester.pumpAndSettle();

        // Assert controller cleared and empty card rendered
        expect(controller.text, isEmpty);
        expect(find.byType(ProductImagePickerEmptyCard), findsOneWidget);
        expect(find.byType(ProductImagePickerFilledCard), findsNothing);
      },
    );

    testWidgets(
      'should display validation error message when validator fails',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        const tError = 'Please select a product image';
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          createWidgetForTesting(
            child: Form(
              key: formKey,
              child: ProductImagePickerCard(
                controller: controller,
                validator: (val) => val == null || val.isEmpty ? tError : null,
              ),
            ),
          ),
        );

        // Act - Validate form
        formKey.currentState!.validate();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(tError), findsOneWidget);
      },
    );

    testWidgets(
      'should navigate to fullScreenImageGalleryView when filled image card is tapped',
      (WidgetTester tester) async {
        setPhoneViewport(tester);
        // Arrange
        controller.text = 'https://example.com/fruit.png';
        var navigatedToGallery = false;

        await tester.pumpWidget(
          createWidgetForTesting(
            routes: {
              Routes.fullScreenImageGalleryView: (context) {
                navigatedToGallery = true;
                return const Scaffold(body: Text('Gallery View'));
              },
            },
            child: ProductImagePickerCard(controller: controller),
          ),
        );

        // Act - Tap on the image area (Hero widget)
        await tester.tap(find.byType(Hero));
        await tester.pumpAndSettle();

        // Assert
        expect(navigatedToGallery, isTrue);
        expect(find.text('Gallery View'), findsOneWidget);
      },
    );
  });
}
