import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/cubits/app_language_cubit.dart';
import 'package:fruit_hub_dashboard/core/services/local_storage/app_preferences_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAppPreferencesService extends Mock implements AppPreferencesService {}

void main() {
  group('AppLanguageCubit', () {
    late MockAppPreferencesService mockPreferencesService;
    late AppLanguageCubit sut;

    setUp(() {
      mockPreferencesService = MockAppPreferencesService();
    });

    tearDown(() {
      sut.close();
    });

    test('initial state should be Locale with language returned by AppPreferencesService', () {
      // Arrange
      when(() => mockPreferencesService.getLanguage()).thenReturn('ar');

      // Act
      sut = AppLanguageCubit(mockPreferencesService);

      // Assert
      expect(sut.state, equals(const Locale('ar')));
      verify(() => mockPreferencesService.getLanguage()).called(1);
    });

    test('initial state should be English Locale when AppPreferencesService returns en', () {
      // Arrange
      when(() => mockPreferencesService.getLanguage()).thenReturn('en');

      // Act
      sut = AppLanguageCubit(mockPreferencesService);

      // Assert
      expect(sut.state, equals(const Locale('en')));
      verify(() => mockPreferencesService.getLanguage()).called(1);
    });

    group('changeLanguage', () {
      blocTest<AppLanguageCubit, Locale>(
        'should emit new Locale and persist languageCode via AppPreferencesService',
        build: () {
          when(() => mockPreferencesService.getLanguage()).thenReturn('ar');
          when(() => mockPreferencesService.saveLanguage('en'))
              .thenAnswer((_) async {});
          sut = AppLanguageCubit(mockPreferencesService);
          return sut;
        },
        act: (cubit) => cubit.changeLanguage('en'),
        expect: () => [const Locale('en')],
        verify: (_) {
          verify(() => mockPreferencesService.saveLanguage('en')).called(1);
        },
      );

      blocTest<AppLanguageCubit, Locale>(
        'should emit Arabic Locale when changing language to ar',
        build: () {
          when(() => mockPreferencesService.getLanguage()).thenReturn('en');
          when(() => mockPreferencesService.saveLanguage('ar'))
              .thenAnswer((_) async {});
          sut = AppLanguageCubit(mockPreferencesService);
          return sut;
        },
        act: (cubit) => cubit.changeLanguage('ar'),
        expect: () => [const Locale('ar')],
        verify: (_) {
          verify(() => mockPreferencesService.saveLanguage('ar')).called(1);
        },
      );

      blocTest<AppLanguageCubit, Locale>(
        'should not emit state and should not call saveLanguage when changing to the already active language',
        build: () {
          when(() => mockPreferencesService.getLanguage()).thenReturn('ar');
          sut = AppLanguageCubit(mockPreferencesService);
          return sut;
        },
        act: (cubit) => cubit.changeLanguage('ar'),
        expect: () => <Locale>[],
        verify: (_) {
          verifyNever(() => mockPreferencesService.saveLanguage(any()));
        },
      );
    });
  });
}
