import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/fetch_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/update_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockFetchShippingConfigUseCase extends Mock
    implements FetchShippingConfigUseCase {}

class MockUpdateShippingConfigUseCase extends Mock
    implements UpdateShippingConfigUseCase {}

class FakeShippingConfigEntity extends Fake implements ShippingConfigEntity {}

void main() {
  late SettingsCubit sut;
  late MockFetchShippingConfigUseCase mockFetchShippingConfigUseCase;
  late MockUpdateShippingConfigUseCase mockUpdateShippingConfigUseCase;

  const tShippingConfig = ShippingConfigEntity(shippingCost: 50.0);
  final tException = Exception('Something went wrong');

  setUpAll(() {
    registerFallbackValue(FakeShippingConfigEntity());
  });

  tearDown(() => sut.close());

  setUp(() {
    mockFetchShippingConfigUseCase = MockFetchShippingConfigUseCase();
    mockUpdateShippingConfigUseCase = MockUpdateShippingConfigUseCase();
    sut = SettingsCubit(
      mockFetchShippingConfigUseCase,
      mockUpdateShippingConfigUseCase,
    );
  });

  group('SettingsCubit', () {
    test('initial state should be SettingsInitial', () {
      expect(sut.state, isA<SettingsInitial>());
    });

    group('fetchShippingConfig', () {
      blocTest(
        'emits [Loading, Success] when data is fetched successfully',
        build: () => sut,
        setUp: () {
          when(() => mockFetchShippingConfigUseCase.call()).thenAnswer(
            (_) async => const NetworkSuccess<ShippingConfigEntity>(tShippingConfig),
          );
        },
        act: (cubit) => cubit.fetchShippingConfig(),
        expect: () => [
          isA<FetchingShippingConfigLoading>(),
          isA<FetchingShippingConfigSuccess>().having(
            (state) => state.shippingConfigEntity.shippingCost,
            'shipping_cost',
            50.0,
          ),
        ],
        verify: (_) {
          verify(() => mockFetchShippingConfigUseCase.call()).called(1);
          verifyNoMoreInteractions(mockFetchShippingConfigUseCase);
        },
      );

      blocTest(
        'emits [Loading, Failure] when fetching fails',
        build: () => sut,
        setUp: () {
          when(() => mockFetchShippingConfigUseCase.call()).thenAnswer(
            (_) async => NetworkFailure<ShippingConfigEntity>(tException),
          );
        },
        act: (cubit) => cubit.fetchShippingConfig(),
        expect: () => [
          isA<FetchingShippingConfigLoading>(),
          isA<FetchingShippingConfigFailure>().having(
            (state) => state.error,
            'message',
            'Something went wrong',
          ),
        ],
        verify: (_) {
          verify(() => mockFetchShippingConfigUseCase.call()).called(1);
          verifyNoMoreInteractions(mockFetchShippingConfigUseCase);
        },
      );
    });

    group('updateShippingConfig', () {
      blocTest(
        'emits [Loading, Success] when update is successful',
        build: () => sut,
        setUp: () {
          when(
            () => mockUpdateShippingConfigUseCase.call(tShippingConfig),
          ).thenAnswer((_) async => const NetworkSuccess<void>(null));
        },
        act: (cubit) => cubit.updateShippingConfig(tShippingConfig),
        expect: () => [
          isA<UpdatingShippingConfigLoading>(),
          isA<UpdatingShippingConfigSuccess>(),
        ],
        verify: (_) {
          verify(() => mockUpdateShippingConfigUseCase.call(tShippingConfig));
          verifyNoMoreInteractions(mockUpdateShippingConfigUseCase);
        },
      );

      blocTest(
        'emits [Loading, Failure] when update fails',
        build: () => sut,
        setUp: () {
          when(
            () => mockUpdateShippingConfigUseCase.call(tShippingConfig),
          ).thenAnswer((_) async => NetworkFailure<void>(tException));
        },
        act: (cubit) => cubit.updateShippingConfig(tShippingConfig),
        expect: () => [
          isA<UpdatingShippingConfigLoading>(),
          isA<UpdatingShippingConfigFailure>().having(
            (state) => state.error,
            'message',
            'Something went wrong',
          ),
        ],
        verify: (_) {
          verify(() => mockUpdateShippingConfigUseCase.call(tShippingConfig));
          verifyNoMoreInteractions(mockUpdateShippingConfigUseCase);
        },
      );
    });
  });
}
