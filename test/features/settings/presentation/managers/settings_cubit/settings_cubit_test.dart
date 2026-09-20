import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_broadcast_notification_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/fetch_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/update_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockFetchShippingConfigUseCase extends Mock
    implements FetchShippingConfigUseCase {}

class MockUpdateShippingConfigUseCase extends Mock
    implements UpdateShippingConfigUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(const ShippingConfigEntity());
  });

  group('SettingsCubit', () {
    late MockFetchShippingConfigUseCase mockFetchShippingConfigUseCase;
    late MockUpdateShippingConfigUseCase mockUpdateShippingConfigUseCase;
    late SettingsCubit sut;

    const tErrorMessage = 'Something went wrong';
    const tFailure = ServerFailure(error: tErrorMessage);

    const tNotificationEntity = ShippingBroadcastNotificationEntity(
      titleAr: 'تحديث الشحن',
      titleEn: 'Shipping Update',
      bodyAr: 'تم تحديث مصاريف الشحن',
      bodyEn: 'Shipping cost has been updated',
      type: 'shipping',
      notify: true,
    );

    const tShippingConfigEntity = ShippingConfigEntity(
      shippingCost: 50.0,
      freeShippingThreshold: 350.0,
      broadcastNotification: tNotificationEntity,
    );

    setUp(() {
      mockFetchShippingConfigUseCase = MockFetchShippingConfigUseCase();
      mockUpdateShippingConfigUseCase = MockUpdateShippingConfigUseCase();
      sut = SettingsCubit(
        mockFetchShippingConfigUseCase,
        mockUpdateShippingConfigUseCase,
      );
    });

    tearDown(() => sut.close());

    test('initial state should be SettingsInitial', () {
      expect(sut.state, isA<SettingsInitial>());
    });

    group('fetchShippingConfig', () {
      blocTest<SettingsCubit, SettingsState>(
        'should emit [FetchingShippingConfigLoading, FetchingShippingConfigSuccess] when fetchShippingConfigUseCase succeeds',
        build: () => sut,
        setUp: () {
          when(() => mockFetchShippingConfigUseCase.call()).thenAnswer(
            (_) async => const NetworkSuccess(tShippingConfigEntity),
          );
        },
        act: (cubit) => cubit.fetchShippingConfig(),
        expect: () => [
          isA<FetchingShippingConfigLoading>(),
          isA<FetchingShippingConfigSuccess>().having(
            (s) => s.shippingConfigEntity,
            'shippingConfigEntity',
            tShippingConfigEntity,
          ),
        ],
        verify: (_) {
          verify(() => mockFetchShippingConfigUseCase.call()).called(1);
          verifyNoMoreInteractions(mockFetchShippingConfigUseCase);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'should emit [FetchingShippingConfigLoading, FetchingShippingConfigFailure] when fetchShippingConfigUseCase fails',
        build: () => sut,
        setUp: () {
          when(() => mockFetchShippingConfigUseCase.call())
              .thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        act: (cubit) => cubit.fetchShippingConfig(),
        expect: () => [
          isA<FetchingShippingConfigLoading>(),
          isA<FetchingShippingConfigFailure>().having(
            (s) => s.error,
            'error',
            tErrorMessage,
          ),
        ],
        verify: (_) {
          verify(() => mockFetchShippingConfigUseCase.call()).called(1);
          verifyNoMoreInteractions(mockFetchShippingConfigUseCase);
        },
      );

      test('should not emit state if cubit is closed before fetchShippingConfig completes', () async {
        // Arrange
        final completer = Completer<NetworkResponse<ShippingConfigEntity>>();
        when(() => mockFetchShippingConfigUseCase.call())
            .thenAnswer((_) => completer.future);

        // Act
        final future = sut.fetchShippingConfig();
        await sut.close();

        completer.complete(const NetworkSuccess(tShippingConfigEntity));
        await future;

        // Assert
        expect(sut.isClosed, isTrue);
      });
    });

    group('updateShippingConfig', () {
      blocTest<SettingsCubit, SettingsState>(
        'should emit [UpdatingShippingConfigLoading, UpdatingShippingConfigSuccess] when updateShippingConfigUseCase succeeds',
        build: () => sut,
        setUp: () {
          when(
            () => mockUpdateShippingConfigUseCase.call(tShippingConfigEntity),
          ).thenAnswer((_) async => const NetworkSuccess(null));
        },
        act: (cubit) => cubit.updateShippingConfig(tShippingConfigEntity),
        expect: () => [
          isA<UpdatingShippingConfigLoading>(),
          isA<UpdatingShippingConfigSuccess>(),
        ],
        verify: (_) {
          verify(
            () => mockUpdateShippingConfigUseCase.call(tShippingConfigEntity),
          ).called(1);
          verifyNoMoreInteractions(mockUpdateShippingConfigUseCase);
        },
      );

      blocTest<SettingsCubit, SettingsState>(
        'should emit [UpdatingShippingConfigLoading, UpdatingShippingConfigFailure] when updateShippingConfigUseCase fails',
        build: () => sut,
        setUp: () {
          when(
            () => mockUpdateShippingConfigUseCase.call(tShippingConfigEntity),
          ).thenAnswer((_) async => const NetworkFailure(tFailure));
        },
        act: (cubit) => cubit.updateShippingConfig(tShippingConfigEntity),
        expect: () => [
          isA<UpdatingShippingConfigLoading>(),
          isA<UpdatingShippingConfigFailure>().having(
            (s) => s.error,
            'error',
            tErrorMessage,
          ),
        ],
        verify: (_) {
          verify(
            () => mockUpdateShippingConfigUseCase.call(tShippingConfigEntity),
          ).called(1);
          verifyNoMoreInteractions(mockUpdateShippingConfigUseCase);
        },
      );

      test('should not emit state if cubit is closed before updateShippingConfig completes', () async {
        // Arrange
        final completer = Completer<NetworkResponse<void>>();
        when(() => mockUpdateShippingConfigUseCase.call(any()))
            .thenAnswer((_) => completer.future);

        // Act
        final future = sut.updateShippingConfig(tShippingConfigEntity);
        await sut.close();

        completer.complete(const NetworkSuccess(null));
        await future;

        // Assert
        expect(sut.isClosed, isTrue);
      });
    });
  });
}
