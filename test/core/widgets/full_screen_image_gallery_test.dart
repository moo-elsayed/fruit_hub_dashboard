import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_assets.dart';
import 'package:fruit_hub_dashboard/core/utils/full_screen_image_gallery_input_item.dart';
import 'package:fruit_hub_dashboard/core/widgets/full_screen_image_gallery.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('FullScreenImageGallery Widget Tests', () {
    testWidgets(
      'should render PageView and counter when multiple images provided',
      (WidgetTester tester) async {
        // Arrange
        const item = FullScreenImageGalleryInputItem(
          imagesPaths: [
            AppAssets.imagesWatermelonTest,
            AppAssets.imagesWatermelonTest,
          ],
          initialIndex: 0,
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const FullScreenImageGallery(item: item),
          ),
        );

        // Assert counter is displayed
        expect(find.text('1 / 2'), findsOneWidget);
        expect(find.byType(PageView), findsOneWidget);

        // Act: Swipe to next page
        await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        // Assert counter updated
        expect(find.text('2 / 2'), findsOneWidget);
      },
    );

    testWidgets(
      'should not render counter title when only single image provided',
      (WidgetTester tester) async {
        // Arrange
        const item = FullScreenImageGalleryInputItem(
          imagesPaths: [AppAssets.imagesWatermelonTest],
          initialIndex: 0,
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const FullScreenImageGallery(item: item),
          ),
        );

        // Assert
        expect(find.text('1 / 1'), findsNothing);
        expect(find.byType(PageView), findsOneWidget);
      },
    );
  });
}
