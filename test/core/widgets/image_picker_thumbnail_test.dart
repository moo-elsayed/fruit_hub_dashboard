import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/image_picker_thumbnail.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('ImagePickerThumbnail Widget Tests', () {
    testWidgets('should render CachedNetworkImage when url starts with http', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const ImagePickerThumbnail(
            path: 'https://example.com/thumbnail.png',
            size: 64,
          ),
        ),
      );

      // Assert
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('should render Image.file when path is a local file path', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const ImagePickerThumbnail(
            path: '/local/path/to/image.png',
            size: 64,
          ),
        ),
      );

      // Assert
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.image, isA<FileImage>());
    });
  });
}
