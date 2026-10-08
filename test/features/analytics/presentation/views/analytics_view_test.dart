import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/managers/analytics_cubit/analytics_cubit.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/views/analytics_view.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_view_body.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';
import '../helpers/mock_analytics_cubit.dart';

void main() {
  group('AnalyticsView Widget Tests', () {
    late MockAnalyticsCubit mockAnalyticsCubit;

    setUpAll(() {
      registerFallbackValue(DateTime.now());
    });

    setUp(() {
      mockAnalyticsCubit = MockAnalyticsCubit();
      when(
        () => mockAnalyticsCubit.loadAnalytics(
          from: any(named: 'from'),
          to: any(named: 'to'),
        ),
      ).thenAnswer((_) async {});
      when(() => mockAnalyticsCubit.state)
          .thenReturn(AnalyticsSuccess(data: getDummyAnalyticsData()));

      if (getIt.isRegistered<AnalyticsCubit>()) {
        getIt.unregister<AnalyticsCubit>();
      }
      getIt.registerLazySingleton<AnalyticsCubit>(() => mockAnalyticsCubit);
    });

    tearDown(() {
      if (getIt.isRegistered<AnalyticsCubit>()) {
        getIt.unregister<AnalyticsCubit>();
      }
    });

    testWidgets('should render CustomAppBar with title and AnalyticsViewBody', (
      tester,
    ) async {
      // Arrange
      const sut = AnalyticsView();

      // Act
      await tester.pumpWidget(createWidgetForTesting(child: sut));
      await tester.pump();

      // Assert
      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.text(AppStrings.analytics), findsOneWidget);
      expect(find.byType(AnalyticsViewBody), findsOneWidget);
      verify(
        () => mockAnalyticsCubit.loadAnalytics(
          from: any(named: 'from'),
          to: any(named: 'to'),
        ),
      ).called(1);
    });

    testWidgets('should pop navigation when back arrow is tapped', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const AnalyticsView())),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(AnalyticsView), findsOneWidget);

      final backButtonFinder = find.descendant(
        of: find.byType(CustomAppBar),
        matching: find.byType(GestureDetector),
      );
      expect(backButtonFinder, findsWidgets);

      await tester.tap(backButtonFinder.first);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AnalyticsView), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    });
  });
}
