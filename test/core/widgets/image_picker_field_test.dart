import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_assets.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet.dart';
import 'package:fruit_hub_dashboard/core/widgets/edit_delete_action_buttons.dart';
import 'package:fruit_hub_dashboard/core/widgets/image_picker_field.dart';
import 'package:fruit_hub_dashboard/core/widgets/image_picker_thumbnail.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('ImagePickerField Widget Tests', () {
    testWidgets('should render empty state when controller text is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: ImagePickerField(
            controller: controller,
            label: 'Fruit Image',
            icon: Icons.image_rounded,
          ),
        ),
      );

      // Assert
      expect(find.text('Fruit Image'), findsOneWidget);
      expect(find.byIcon(Icons.image_rounded), findsOneWidget);
      expect(find.byIcon(Icons.add_photo_alternate_outlined), findsOneWidget);
      expect(find.byType(ImagePickerThumbnail), findsNothing);
    });

    testWidgets(
      'should render filled state with thumbnail and delete button when controller has text',
      (WidgetTester tester) async {
        // Arrange
        final controller = TextEditingController(
          text: AppAssets.imagesWatermelonTest,
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: ImagePickerField(
              controller: controller,
              label: 'Selected Image',
              icon: Icons.image_rounded,
            ),
          ),
        );

        // Assert
        expect(find.byType(ImagePickerThumbnail), findsOneWidget);
        expect(find.text('Selected Image'), findsOneWidget);
        expect(find.byType(EditDeleteActionButtons), findsOneWidget);

        // Act: Delete image
        await tester.tap(find.byIcon(Icons.delete_outline_rounded));
        await tester.pump();

        // Assert controller cleared and empty state returned
        expect(controller.text, isEmpty);
        expect(find.byType(ImagePickerThumbnail), findsNothing);
      },
    );

    testWidgets(
      'should open bottom sheet with camera and gallery options when tapped',
      (WidgetTester tester) async {
        // Arrange
        final controller = TextEditingController();

        await tester.pumpWidget(
          createWidgetForTesting(
            child: ImagePickerField(
              controller: controller,
              label: 'Upload Picture',
              icon: Icons.camera_rounded,
            ),
          ),
        );

        // Act: Tap the empty container text
        await tester.tap(find.text('Upload Picture'));
        await tester.pumpAndSettle();

        // Assert bottom sheet opened
        expect(find.byType(CustomBottomSheet), findsOneWidget);
        expect(find.text(AppStrings.chooseImageSource), findsOneWidget);
        expect(find.text(AppStrings.camera), findsOneWidget);
        expect(find.text(AppStrings.gallery), findsOneWidget);
      },
    );

    testWidgets('should show validation error text when validator fails', (
      WidgetTester tester,
    ) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        createWidgetForTesting(
          child: Form(
            key: formKey,
            child: ImagePickerField(
              controller: controller,
              label: 'Cover Photo',
              icon: Icons.image_rounded,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Image is required' : null,
            ),
          ),
        ),
      );

      // Act: Trigger validation
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      // Assert error displayed
      expect(find.text('Image is required'), findsOneWidget);
    });
  });
}
