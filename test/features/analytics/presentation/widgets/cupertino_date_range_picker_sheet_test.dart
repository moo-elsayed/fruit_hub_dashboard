import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/cupertino_date_range_picker_sheet.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar', null);
    await initializeDateFormatting('en', null);
  });

  group('CupertinoDateRangePickerSheet Widget Tests', () {
    testWidgets(
      'should render header, start and end tabs, and apply button correctly',
      (tester) async {
        // Arrange
        final start = DateTime(2026, 9, 1);
        final end = DateTime(2026, 9, 10);
        DateTimeRange? confirmedRange;

        final sut = CupertinoDateRangePickerSheet(
          initialRange: DateTimeRange(start: start, end: end),
          firstDate: DateTime(2025, 1, 1),
          lastDate: DateTime(2026, 12, 31),
          onConfirmed: (range) => confirmedRange = range,
        );

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text(AppStrings.selectDateRange), findsOneWidget);
        expect(find.text(AppStrings.startDate), findsOneWidget);
        expect(find.text(AppStrings.endDate), findsOneWidget);
        expect(find.text(AppStrings.apply), findsOneWidget);
        expect(find.byType(CupertinoDatePicker), findsOneWidget);

        // Tap apply
        await tester.tap(find.text(AppStrings.apply));
        await tester.pumpAndSettle();

        expect(confirmedRange, isNotNull);
        expect(confirmedRange!.start, start);
        expect(confirmedRange!.end, end);
      },
    );

    testWidgets(
      'should switch active tab and update date when picker changes',
      (tester) async {
        // Arrange
        final start = DateTime(2026, 9, 1);
        final initialEnd = DateTime(2026, 9, 10);
        final newEnd = DateTime(2026, 9, 20);
        DateTimeRange? confirmedRange;

        final sut = CupertinoDateRangePickerSheet(
          initialRange: DateTimeRange(start: start, end: initialEnd),
          firstDate: DateTime(2025, 1, 1),
          lastDate: DateTime(2026, 12, 31),
          onConfirmed: (range) => confirmedRange = range,
        );

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Initially active tab is start date (key 0)
        expect(find.byKey(const ValueKey<int>(0)), findsOneWidget);
        expect(find.byKey(const ValueKey<int>(1)), findsNothing);

        // Tap end date tab
        await tester.tap(find.text(AppStrings.endDate));
        await tester.pumpAndSettle();

        // Active tab switched to end date (key 1)
        expect(find.byKey(const ValueKey<int>(1)), findsOneWidget);
        expect(find.byKey(const ValueKey<int>(0)), findsNothing);

        // Change date in picker
        final picker = tester.widget<CupertinoDatePicker>(
          find.byType(CupertinoDatePicker),
        );
        picker.onDateTimeChanged(newEnd);
        await tester.pumpAndSettle();

        // Tap apply
        await tester.tap(find.text(AppStrings.apply));
        await tester.pumpAndSettle();

        // Assert that new end date is confirmed
        expect(confirmedRange, isNotNull);
        expect(confirmedRange!.start, start);
        expect(confirmedRange!.end, newEnd);
      },
    );

    testWidgets(
      'should automatically swap start and end dates if start is set after end',
      (tester) async {
        // Arrange
        final initialStart = DateTime(2026, 9, 1);
        final initialEnd = DateTime(2026, 9, 10);
        final newStartAfterEnd = DateTime(2026, 9, 25);
        DateTimeRange? confirmedRange;

        final sut = CupertinoDateRangePickerSheet(
          initialRange: DateTimeRange(start: initialStart, end: initialEnd),
          firstDate: DateTime(2025, 1, 1),
          lastDate: DateTime(2026, 12, 31),
          onConfirmed: (range) => confirmedRange = range,
        );

        // Act
        await tester.pumpWidget(createWidgetForTesting(child: sut));
        await tester.pumpAndSettle();

        // Active tab is start date (key 0). Change start date to 2026-09-25 (after end)
        final picker = tester.widget<CupertinoDatePicker>(
          find.byType(CupertinoDatePicker),
        );
        picker.onDateTimeChanged(newStartAfterEnd);
        await tester.pumpAndSettle();

        // Tap apply
        await tester.tap(find.text(AppStrings.apply));
        await tester.pumpAndSettle();

        // Assert: swapped so start is 2026-09-10 and end is 2026-09-25
        expect(confirmedRange, isNotNull);
        expect(confirmedRange!.start, initialEnd);
        expect(confirmedRange!.end, newStartAfterEnd);
      },
    );
  });
}
