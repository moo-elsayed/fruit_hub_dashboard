import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/settings_repo/settings_repo.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/update_shipping_config_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

void main() {
  late UpdateShippingConfigUseCase sut;
  late MockSettingsRepo mockSettingsRepo;

  final tShippingConfigEntityForUpdate = const ShippingConfigEntity(
    shippingCost: 70.0,
  );

  final tSuccessResponseOfTypeVoid = const NetworkSuccess<void>(null);
  final tFailureResponseOfTypeVoid = NetworkFailure<void>(
    Exception("permission-denied"),
  );

  setUpAll(() {
    registerFallbackValue(const ShippingConfigEntity());
  });

  setUp(() {
    mockSettingsRepo = MockSettingsRepo();
    sut = UpdateShippingConfigUseCase(mockSettingsRepo);
  });

  group("UpdateShippingConfigUseCase", () {
    test(
      'should return NetworkSuccess when updateShippingConfig is successful',
      () async {
        // Arrange
        when(
          () => mockSettingsRepo.updateShippingConfig(
            tShippingConfigEntityForUpdate,
          ),
        ).thenAnswer((_) async => tSuccessResponseOfTypeVoid);
        // Act
        final result = await sut.call(tShippingConfigEntityForUpdate);
        // Assert
        expect(result, tSuccessResponseOfTypeVoid);
        verify(() => mockSettingsRepo.updateShippingConfig(any())).called(1);
        verifyNoMoreInteractions(mockSettingsRepo);
      },
    );
    test(
      'should return NetworkFailure when updateShippingConfig throws an exception',
      () async {
        // Arrange
        when(
          () => mockSettingsRepo.updateShippingConfig(
            tShippingConfigEntityForUpdate,
          ),
        ).thenAnswer((_) async => tFailureResponseOfTypeVoid);
        // Act
        final result = await sut.call(tShippingConfigEntityForUpdate);
        // Assert
        expect(result, tFailureResponseOfTypeVoid);
        verify(() => mockSettingsRepo.updateShippingConfig(any())).called(1);
        verifyNoMoreInteractions(mockSettingsRepo);
      },
    );
  });
}
