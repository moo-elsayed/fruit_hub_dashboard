import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/analytics_date_filter.dart';
import 'package:fruit_hub_dashboard/core/widgets/search_filter_chip.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/managers/analytics_cubit/analytics_cubit.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_date_filter_bar.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/cupertino_date_range_picker_sheet.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';
import '../helpers/mock_analytics_cubit.dart';

void main() {
  group('AnalyticsDateFilterBar Widget Tests', () {
    late MockAnalyticsCubit mockAnalyticsCubit;
    late ValueNotifier<AnalyticsDateFilter> selectedFilter;
    late ValueNotifier<DateTimeRange?> customRangeNotifier;

    setUpAll(() async {
      await initializeDateFormatting('ar', null);
      await initializeDateFormatting('en', null);
      registerFallbackValue(DateTime.now());
    });

    setUp(() {
      mockAnalyticsCubit = MockAnalyticsCubit();
      selectedFilter = ValueNotifier(AnalyticsDateFilter.last7Days);
      customRangeNotifier = ValueNotifier(null);

      when(
        () => mockAnalyticsCubit.loadAnalytics(
          from: any(named: 'from'),
          to: any(named: 'to'),
        ),
      ).thenAnswer((_) async {});
    });

    tearDown(() {
      selectedFilter.dispose();
      customRangeNotifier.dispose();
    });

    void setPhoneViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    }

    testWidgets('should render all date filter chips', (tester) async {
      // Arrange
      setPhoneViewport(tester);
      final sut = AnalyticsDateFilterBar(
        selectedFilter: selectedFilter,
        customRangeNotifier: customRangeNotifier,
      );

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: BlocProvider<AnalyticsCubit>.value(
            value: mockAnalyticsCubit,
            child: sut,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.byType(SearchFilterChip),
        findsNWidgets(AnalyticsDateFilter.values.length),
      );
      for (final filter in AnalyticsDateFilter.values) {
        expect(find.text(filter.title), findsOneWidget);
      }
    });

    testWidgets(
      'should update selectedFilter and call loadAnalytics when preset chip is tapped',
      (tester) async {
        // Arrange
        setPhoneViewport(tester);
        final sut = AnalyticsDateFilterBar(
          selectedFilter: selectedFilter,
          customRangeNotifier: customRangeNotifier,
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<AnalyticsCubit>.value(
              value: mockAnalyticsCubit,
              child: sut,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap 'آخر 30 يوم' (last30Days)
        await tester.ensureVisible(
          find.text(AnalyticsDateFilter.last30Days.title),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(AnalyticsDateFilter.last30Days.title));
        await tester.pumpAndSettle();

        // Assert
        expect(selectedFilter.value, AnalyticsDateFilter.last30Days);
        verify(
          () => mockAnalyticsCubit.loadAnalytics(
            from: any(named: 'from'),
            to: any(named: 'to'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'should open CupertinoDateRangePickerSheet when custom filter is tapped',
      (tester) async {
        // Arrange
        setPhoneViewport(tester);
        final sut = AnalyticsDateFilterBar(
          selectedFilter: selectedFilter,
          customRangeNotifier: customRangeNotifier,
        );

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<AnalyticsCubit>.value(
              value: mockAnalyticsCubit,
              child: sut,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Ensure custom filter is visible before tapping
        final customFinder = find.text(AnalyticsDateFilter.custom.title);
        await tester.ensureVisible(customFinder);
        await tester.pumpAndSettle();

        await tester.tap(customFinder);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CupertinoDateRangePickerSheet), findsOneWidget);
      },
    );
  });
}
