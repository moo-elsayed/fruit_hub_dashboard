import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/cubits/app_language_cubit.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/core/theming/app_theme_cubit.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_arrow_back.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_error_view.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/views/settings_view.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/delivery_fees_container.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/settings_preferences_card.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockSettingsCubit extends MockCubit<SettingsState>
    implements SettingsCubit {}

class MockAppLanguageCubit extends MockCubit<Locale>
    implements AppLanguageCubit {}

class MockAppThemeCubit extends MockCubit<ThemeMode> implements AppThemeCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSettingsCubit mockSettingsCubit;
  late MockAppLanguageCubit mockAppLanguageCubit;
  late MockAppThemeCubit mockAppThemeCubit;
  late StreamController<SettingsState> stateController;

  const tShippingConfig = ShippingConfigEntity(
    shippingCost: 40.0,
    freeShippingThreshold: 300.0,
  );

  setUp(() {
    mockSettingsCubit = MockSettingsCubit();
    mockAppLanguageCubit = MockAppLanguageCubit();
    mockAppThemeCubit = MockAppThemeCubit();
    stateController = StreamController<SettingsState>.broadcast();

    when(() => mockSettingsCubit.state).thenReturn(SettingsInitial());
    when(() => mockSettingsCubit.stream)
        .thenAnswer((_) => stateController.stream);
    when(() => mockSettingsCubit.fetchShippingConfig())
        .thenAnswer((_) async {});

    when(() => mockAppLanguageCubit.state).thenReturn(const Locale('en'));
    when(() => mockAppThemeCubit.state).thenReturn(ThemeMode.light);

    if (getIt.isRegistered<SettingsCubit>()) {
      getIt.unregister<SettingsCubit>();
    }
    getIt.registerFactory<SettingsCubit>(() => mockSettingsCubit);
  });

  tearDown(() {
    stateController.close();
    if (getIt.isRegistered<SettingsCubit>()) {
      getIt.unregister<SettingsCubit>();
    }
  });

  Widget wrapWithProviders(Widget child) => MultiBlocProvider(
    providers: [
      BlocProvider<AppLanguageCubit>.value(value: mockAppLanguageCubit),
      BlocProvider<AppThemeCubit>.value(value: mockAppThemeCubit),
    ],
    child: child,
  );

  Widget buildWidget({Widget? child}) => createWidgetForTesting(
    child: wrapWithProviders(child ?? const SettingsView()),
  );

  group('SettingsView Widget Tests', () {
    testWidgets(
      'should render CustomAppBar and call fetchShippingConfig on init',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pump();

        // Assert
        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.text(AppStrings.settings), findsOneWidget);
        expect(find.byType(CustomArrowBack), findsOneWidget);
        verify(() => mockSettingsCubit.fetchShippingConfig()).called(1);
      },
    );

    testWidgets('should pop view when back arrow is tapped', (
      WidgetTester tester,
    ) async {
      // Arrange: use Success state so animations settle
      when(() => mockSettingsCubit.state)
          .thenReturn(FetchingShippingConfigSuccess(tShippingConfig));

      await tester.pumpWidget(
        createWidgetForTesting(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => wrapWithProviders(const SettingsView()),
                ),
              ),
              child: const Text('Open Settings'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open SettingsView
      await tester.tap(find.text('Open Settings'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsView), findsOneWidget);

      // Act: tap back arrow
      await tester.tap(find.byType(CustomArrowBack));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SettingsView), findsNothing);
      expect(find.text('Open Settings'), findsOneWidget);
    });

    testWidgets(
      'should render Skeletonizer loading state when state is FetchingShippingConfigLoading',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockSettingsCubit.state)
            .thenReturn(FetchingShippingConfigLoading());

        // Act
        await tester.pumpWidget(buildWidget());
        await tester.pump();

        // Assert
        expect(
          find.byWidgetPredicate(
            (w) => w.runtimeType.toString() == '_Skeletonizer',
          ),
          findsOneWidget,
        );
        expect(find.text(AppStrings.generalConfiguration), findsOneWidget);
        expect(find.text(AppStrings.generalSettings), findsOneWidget);
      },
    );

    testWidgets(
      'should render DeliveryFeesContainer and SettingsPreferencesCard when state is FetchingShippingConfigSuccess',
      (WidgetTester tester) async {
        // Arrange
        when(() => mockSettingsCubit.state)
            .thenReturn(FetchingShippingConfigSuccess(tShippingConfig));

        // Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(DeliveryFeesContainer), findsOneWidget);
        expect(find.byType(SettingsPreferencesCard), findsOneWidget);
        expect(find.text(AppStrings.generalConfiguration), findsOneWidget);
        expect(find.text(AppStrings.generalSettings), findsOneWidget);
      },
    );

    testWidgets(
      'should render CustomErrorView with error message and call fetchShippingConfig when retry is tapped',
      (WidgetTester tester) async {
        // Arrange
        const tError = 'Failed to load shipping config';
        when(() => mockSettingsCubit.state)
            .thenReturn(FetchingShippingConfigFailure(tError));

        // Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();
        clearInteractions(mockSettingsCubit);

        // Assert
        expect(find.byType(CustomErrorView), findsOneWidget);
        expect(find.text(tError), findsOneWidget);

        // Act: tap retry
        await tester.tap(find.text(AppStrings.retry));
        await tester.pump();

        // Assert: fetchShippingConfig was called (1 on retry only because of clearInteractions)
        verify(() => mockSettingsCubit.fetchShippingConfig()).called(1);
      },
    );
  });
}
