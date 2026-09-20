import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/services/local_storage/app_preferences_service.dart';
import 'package:fruit_hub_dashboard/core/theming/app_theme_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

void main() {
  late MockAppPreferencesService mockAppPreferencesService;
  late AppThemeCubit sut;

  setUp(() {
    mockAppPreferencesService = MockAppPreferencesService();
  });

  group('AppThemeCubit', () {
    test(
      'initial state should emit ThemeMode.light when saved theme is light',
      () {
        // Arrange
        when(() => mockAppPreferencesService.getThemeMode())
            .thenReturn('light');

        // Act
        sut = AppThemeCubit(mockAppPreferencesService);

        // Assert
        expect(sut.state, equals(ThemeMode.light));
        verify(() => mockAppPreferencesService.getThemeMode()).called(1);
        sut.close();
      },
    );

    test(
      'initial state should emit ThemeMode.dark when saved theme is dark',
      () {
        // Arrange
        when(() => mockAppPreferencesService.getThemeMode()).thenReturn('dark');

        // Act
        sut = AppThemeCubit(mockAppPreferencesService);

        // Assert
        expect(sut.state, equals(ThemeMode.dark));
        verify(() => mockAppPreferencesService.getThemeMode()).called(1);
        sut.close();
      },
    );

    test(
      'initial state should emit ThemeMode.system when saved theme is system',
      () {
        // Arrange
        when(() => mockAppPreferencesService.getThemeMode())
            .thenReturn('system');

        // Act
        sut = AppThemeCubit(mockAppPreferencesService);

        // Assert
        expect(sut.state, equals(ThemeMode.system));
        verify(() => mockAppPreferencesService.getThemeMode()).called(1);
        sut.close();
      },
    );

    test('initial state should default to ThemeMode.system when saved theme is unrecognized', () {
      // Arrange
      when(() => mockAppPreferencesService.getThemeMode())
          .thenReturn('unknown_theme');

      // Act
      sut = AppThemeCubit(mockAppPreferencesService);

      // Assert
      expect(sut.state, equals(ThemeMode.system));
      verify(() => mockAppPreferencesService.getThemeMode()).called(1);
      sut.close();
    });

    blocTest<AppThemeCubit, ThemeMode>(
      'emits [ThemeMode.light] and saves light when changeTheme(ThemeMode.light) is called',
      build: () {
        when(() => mockAppPreferencesService.getThemeMode())
            .thenReturn('system');
        when(() => mockAppPreferencesService.saveThemeMode('light'))
            .thenAnswer((_) async {});
        sut = AppThemeCubit(mockAppPreferencesService);
        return sut;
      },
      act: (cubit) => cubit.changeTheme(ThemeMode.light),
      expect: () => [ThemeMode.light],
      verify: (_) {
        verify(() => mockAppPreferencesService.saveThemeMode('light'))
            .called(1);
      },
    );

    blocTest<AppThemeCubit, ThemeMode>(
      'emits [ThemeMode.dark] and saves dark when changeTheme(ThemeMode.dark) is called',
      build: () {
        when(() => mockAppPreferencesService.getThemeMode())
            .thenReturn('system');
        when(() => mockAppPreferencesService.saveThemeMode('dark'))
            .thenAnswer((_) async {});
        sut = AppThemeCubit(mockAppPreferencesService);
        return sut;
      },
      act: (cubit) => cubit.changeTheme(ThemeMode.dark),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        verify(() => mockAppPreferencesService.saveThemeMode('dark')).called(1);
      },
    );

    blocTest<AppThemeCubit, ThemeMode>(
      'emits [ThemeMode.system] and saves system when changeTheme(ThemeMode.system) is called',
      build: () {
        when(() => mockAppPreferencesService.getThemeMode())
            .thenReturn('light');
        when(() => mockAppPreferencesService.saveThemeMode('system'))
            .thenAnswer((_) async {});
        sut = AppThemeCubit(mockAppPreferencesService);
        return sut;
      },
      act: (cubit) => cubit.changeTheme(ThemeMode.system),
      expect: () => [ThemeMode.system],
      verify: (_) {
        verify(() => mockAppPreferencesService.saveThemeMode('system'))
            .called(1);
      },
    );

    blocTest<AppThemeCubit, ThemeMode>(
      'should not emit state and should not call saveThemeMode when changing to the already active theme',
      build: () {
        when(() => mockAppPreferencesService.getThemeMode()).thenReturn('dark');
        sut = AppThemeCubit(mockAppPreferencesService);
        return sut;
      },
      act: (cubit) => cubit.changeTheme(ThemeMode.dark),
      expect: () => <ThemeMode>[],
      verify: (_) {
        verifyNever(() => mockAppPreferencesService.saveThemeMode(any()));
      },
    );
  });
}
