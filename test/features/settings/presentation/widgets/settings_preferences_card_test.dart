import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/cubits/app_language_cubit.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/theming/app_theme_cubit.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/settings_preference_tile.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/widgets/settings_preferences_card.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_widget_wrapper.dart';

class MockAppLanguageCubit extends MockCubit<Locale>
    implements AppLanguageCubit {}

class MockAppThemeCubit extends MockCubit<ThemeMode> implements AppThemeCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(ThemeMode.light);
  });

  late MockAppLanguageCubit mockAppLanguageCubit;
  late MockAppThemeCubit mockAppThemeCubit;

  setUp(() {
    mockAppLanguageCubit = MockAppLanguageCubit();
    mockAppThemeCubit = MockAppThemeCubit();

    when(() => mockAppLanguageCubit.state).thenReturn(const Locale('en'));
    when(() => mockAppLanguageCubit.changeLanguage(any()))
        .thenAnswer((_) async {});

    when(() => mockAppThemeCubit.state).thenReturn(ThemeMode.light);
    when(() => mockAppThemeCubit.changeTheme(any())).thenAnswer((_) async {});
  });

  Widget buildWidget({Locale locale = const Locale('en')}) =>
      createWidgetForTesting(
        locale: locale,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppLanguageCubit>.value(value: mockAppLanguageCubit),
            BlocProvider<AppThemeCubit>.value(value: mockAppThemeCubit),
          ],
          child: const SettingsPreferencesCard(),
        ),
      );

  group('SettingsPreferencesCard Widget Tests', () {
    testWidgets(
      'should render language and theme preference tiles with correct labels',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());

        // Assert
        expect(find.byType(SettingsPreferenceTile), findsNWidgets(2));
        expect(find.text(AppStrings.language), findsOneWidget);
        expect(find.text(AppStrings.theme), findsOneWidget);
        expect(find.text(AppStrings.english), findsOneWidget);
        expect(find.text(AppStrings.light), findsOneWidget);
      },
    );

    testWidgets(
      'should show language bottom sheet and trigger changeLanguage when language option is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());

        // Act: tap language tile
        await tester.tap(find.text(AppStrings.language));
        await tester.pumpAndSettle();

        // Assert: bottom sheet is shown
        expect(find.text(AppStrings.selectLanguage), findsOneWidget);
        expect(find.text(AppStrings.arabic), findsOneWidget);
        expect(find.text(AppStrings.english), findsWidgets);

        // Act: select Arabic
        await tester.tap(find.text(AppStrings.arabic));
        await tester.pumpAndSettle();

        // Assert: cubit was invoked
        verify(() => mockAppLanguageCubit.changeLanguage('ar')).called(1);
      },
    );

    testWidgets(
      'should show theme bottom sheet and trigger changeTheme when theme option is tapped',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget());

        // Act: tap theme tile
        await tester.tap(find.text(AppStrings.theme));
        await tester.pumpAndSettle();

        // Assert: bottom sheet is shown
        expect(find.text(AppStrings.theme), findsWidgets);
        expect(find.text(AppStrings.light), findsWidgets);
        expect(find.text(AppStrings.dark), findsOneWidget);
        expect(find.text(AppStrings.system), findsOneWidget);

        // Act: select Dark theme
        await tester.tap(find.text(AppStrings.dark));
        await tester.pumpAndSettle();

        // Assert: cubit was invoked
        verify(() => mockAppThemeCubit.changeTheme(ThemeMode.dark)).called(1);
      },
    );
  });
}
