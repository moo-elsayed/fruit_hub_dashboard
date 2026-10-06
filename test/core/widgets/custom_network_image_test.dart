import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_assets.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_network_image.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomNetworkImage Widget Tests', () {
    testWidgets('should render placeholder asset image when url is empty', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const CustomNetworkImage(image: '')),
      );

      // Assert
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      final assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, equals(AppAssets.imagesWatermelonTest));
    });

    testWidgets(
      'should render CachedNetworkImage when valid http url is provided',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const CustomNetworkImage(
              image: 'https://example.com/fruit.jpg',
              height: 100,
              width: 100,
            ),
          ),
        );

        // Assert
        final cachedImageFinder = find.byType(CachedNetworkImage);
        expect(cachedImageFinder, findsOneWidget);
        final cachedImage = tester.widget<CachedNetworkImage>(
          cachedImageFinder,
        );
        expect(cachedImage.imageUrl, equals('https://example.com/fruit.jpg'));
      },
    );
  });
}
