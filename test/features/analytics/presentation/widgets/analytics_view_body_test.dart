import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/managers/analytics_cubit/analytics_cubit.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_date_filter_bar.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_failure_widget.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_kpi_section.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_skeleton_body.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_view_body.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/order_status_distribution_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/payment_methods_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/revenue_timeline_chart_card.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/top_selling_products_card.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';
import '../helpers/mock_analytics_cubit.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ar', null);
    await initializeDateFormatting('en', null);
  });

  group('AnalyticsViewBody Widget Tests', () {
    late MockAnalyticsCubit mockAnalyticsCubit;

    void setPhoneViewport(WidgetTester tester) {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    }

    setUp(() {
      mockAnalyticsCubit = MockAnalyticsCubit();
      when(() => mockAnalyticsCubit.refresh()).thenAnswer((_) async {});
    });

    testWidgets(
      'should render filter bar and skeleton body when state is AnalyticsLoading',
      (tester) async {
        // Arrange
        when(() => mockAnalyticsCubit.state).thenReturn(AnalyticsLoading());
        const sut = AnalyticsViewBody();

        // Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: BlocProvider<AnalyticsCubit>.value(
              value: mockAnalyticsCubit,
              child: sut,
            ),
          ),
        );
        await tester.pump();

        // Assert
        expect(find.byType(AnalyticsDateFilterBar), findsOneWidget);
        expect(find.byType(AnalyticsSkeletonBody), findsOneWidget);
      },
    );

    testWidgets(
      'should render AnalyticsFailureWidget when state is AnalyticsFailure',
      (tester) async {
        // Arrange
        const errorMsg = 'تعذر الاتصال بالخادم';
        when(() => mockAnalyticsCubit.state)
            .thenReturn(const AnalyticsFailure(message: errorMsg));
        const sut = AnalyticsViewBody();

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
        expect(find.byType(AnalyticsDateFilterBar), findsOneWidget);
        expect(find.byType(AnalyticsFailureWidget), findsOneWidget);
        expect(find.text(errorMsg), findsOneWidget);
      },
    );

    testWidgets(
      'should render all analytics section cards when state is AnalyticsSuccess',
      (tester) async {
        // Arrange
        setPhoneViewport(tester);
        final dummyData = getDummyAnalyticsData();
        when(() => mockAnalyticsCubit.state)
            .thenReturn(AnalyticsSuccess(data: dummyData));
        const sut = AnalyticsViewBody();

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
        expect(find.byType(AnalyticsDateFilterBar), findsOneWidget);
        expect(find.byType(AnalyticsKpiSection), findsOneWidget);
        expect(find.byType(RevenueTimelineChartCard), findsOneWidget);

        // Scroll down to reveal remaining cards
        await tester.drag(find.byType(ListView), const Offset(0, -800));
        await tester.pumpAndSettle();

        expect(find.byType(OrderStatusDistributionCard), findsOneWidget);
        expect(find.byType(PaymentMethodsCard), findsOneWidget);
        expect(find.byType(TopSellingProductsCard), findsOneWidget);
      },
    );

    testWidgets('should call refresh when pull-to-refresh is triggered', (
      tester,
    ) async {
      // Arrange
      setPhoneViewport(tester);
      final dummyData = getDummyAnalyticsData();
      when(() => mockAnalyticsCubit.state)
          .thenReturn(AnalyticsSuccess(data: dummyData));
      const sut = AnalyticsViewBody();

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

      // Drag down to trigger RefreshIndicator
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Assert
      verify(() => mockAnalyticsCubit.refresh()).called(1);
    });
  });
}
