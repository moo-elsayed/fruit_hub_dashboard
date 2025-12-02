import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/settings_repo/settings_repo.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/fetch_shipping_config_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

void main() {
  late FetchShippingConfigUseCase sut;
  late MockSettingsRepo mockSettingsRepo;

  final tShippingConfigEntity = const ShippingConfigEntity(shippingCost: 50.0);
  final tSuccessResponseOfTypeShippingConfigEntity =
      NetworkSuccess<ShippingConfigEntity>(tShippingConfigEntity);
  final tFailureResponseOfTypeShippingConfigEntity =
      NetworkFailure<ShippingConfigEntity>(Exception("permission-denied"));

  setUp(() {
    mockSettingsRepo = MockSettingsRepo();
    sut = FetchShippingConfigUseCase(mockSettingsRepo);
  });

  group("FetchShippingConfigUseCase", () {
    test(
      'should return NetworkSuccess when fetchShippingConfig is successful',
      () async {
        // Arrange
        when(
          () => mockSettingsRepo.fetchShippingConfig(),
        ).thenAnswer((_) async => tSuccessResponseOfTypeShippingConfigEntity);
        // Act
        final result = await sut.call();
        // Assert
        expect(result, tSuccessResponseOfTypeShippingConfigEntity);
        verify(() => mockSettingsRepo.fetchShippingConfig()).called(1);
        verifyNoMoreInteractions(mockSettingsRepo);
      },
    );

    test(
      'should return NetworkFailure when fetchShippingConfig throws an exception',
      () async {
        // Arrange
        when(
          () => mockSettingsRepo.fetchShippingConfig(),
        ).thenAnswer((_) async => tFailureResponseOfTypeShippingConfigEntity);
        // Act
        final result = await sut.call();
        // Assert
        expect(result, tFailureResponseOfTypeShippingConfigEntity);
        verify(() => mockSettingsRepo.fetchShippingConfig()).called(1);
        verifyNoMoreInteractions(mockSettingsRepo);
      },
    );
  });
}
