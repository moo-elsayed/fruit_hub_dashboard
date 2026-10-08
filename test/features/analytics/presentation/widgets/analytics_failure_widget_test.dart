import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/managers/analytics_cubit/analytics_cubit.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/analytics_failure_widget.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';
import '../helpers/mock_analytics_cubit.dart';

void main() {
  group('AnalyticsFailureWidget Widget Tests', () {
    late MockAnalyticsCubit mockAnalyticsCubit;

    setUp(() {
      mockAnalyticsCubit = MockAnalyticsCubit();
      when(() => mockAnalyticsCubit.refresh()).thenAnswer((_) async {});
    });

    testWidgets(
      'should render error icon, message, and retry button correctly',
      (tester) async {
        // Arrange
        const errorMessage = 'حدث خطأ أثناء تحميل البيانات';
        const sut = AnalyticsFailureWidget(message: errorMessage);

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
        expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.text(AppStrings.retry), findsOneWidget);
      },
    );

    testWidgets(
      'should call AnalyticsCubit.refresh when retry button is tapped',
      (tester) async {
        // Arrange
        const sut = AnalyticsFailureWidget(message: 'Error');

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

        await tester.tap(find.text(AppStrings.retry));
        await tester.pumpAndSettle();

        // Assert
        verify(() => mockAnalyticsCubit.refresh()).called(1);
      },
    );
  });
}
