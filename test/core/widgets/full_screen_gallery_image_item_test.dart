import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_assets.dart';
import 'package:fruit_hub_dashboard/core/widgets/full_screen_gallery_image_item.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('FullScreenGalleryImageItem Widget Tests', () {
    testWidgets('should render CachedNetworkImage for http urls', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const FullScreenGalleryImageItem(
            path: 'https://example.com/gallery.jpg',
          ),
        ),
      );

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should render AssetImage when path starts with assets/', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const FullScreenGalleryImageItem(
            path: AppAssets.imagesWatermelonTest,
          ),
        ),
      );

      // Assert
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<AssetImage>());
    });

    testWidgets('should render FileImage when path is a local file path', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const FullScreenGalleryImageItem(
            path: '/data/user/0/cache/photo.jpg',
          ),
        ),
      );

      // Assert
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<FileImage>());
    });
  });
}
