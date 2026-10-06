import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_bottom_sheet_handle.dart';

import '../../helpers/test_widget_wrapper.dart';

void main() {
  group('CustomBottomSheetHandle Widget Tests', () {
    testWidgets('should render handle with default margin', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(child: const CustomBottomSheetHandle()),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      final margin = container.margin as EdgeInsets?;
      expect(margin?.bottom, equals(12.h));
    });

    testWidgets('should apply custom bottom gap margin', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const CustomBottomSheetHandle(bottomGap: 24),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      final margin = container.margin as EdgeInsets?;
      expect(margin?.bottom, equals(24.h));
    });
  });
}
