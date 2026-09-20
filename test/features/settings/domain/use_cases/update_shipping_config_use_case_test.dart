import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_broadcast_notification_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/settings_repo/settings_repo.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/update_shipping_config_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

void main() {
  group('UpdateShippingConfigUseCase', () {
    late MockSettingsRepo mockSettingsRepo;
    late UpdateShippingConfigUseCase sut;

    const tFailure = ServerFailure(
      error: 'Failed to update shipping configuration',
    );

    const tNotificationEntity = ShippingBroadcastNotificationEntity(
      titleAr: 'تحديث الشحن',
      titleEn: 'Shipping Update',
      bodyAr: 'تم تعديل مصاريف التوصيل',
      bodyEn: 'Delivery fees have been updated',
      type: 'shipping',
      notify: true,
    );

    const tShippingConfigEntity = ShippingConfigEntity(
      shippingCost: 45.0,
      freeShippingThreshold: 350.0,
      broadcastNotification: tNotificationEntity,
    );

    setUp(() {
      mockSettingsRepo = MockSettingsRepo();
      sut = UpdateShippingConfigUseCase(mockSettingsRepo);
    });

    test('should forward shippingConfigEntity to SettingsRepo and return NetworkSuccess(null) on success', () async {
      // Arrange
      when(() => mockSettingsRepo.updateShippingConfig(tShippingConfigEntity))
          .thenAnswer((_) async => const NetworkSuccess(null));

      // Act
      final result = await sut(tShippingConfigEntity);

      // Assert
      expect(result, isA<NetworkSuccess<void>>());

      verify(() => mockSettingsRepo.updateShippingConfig(tShippingConfigEntity))
          .called(1);
      verifyNoMoreInteractions(mockSettingsRepo);
    });

    test(
      'should return NetworkFailure when SettingsRepo returns NetworkFailure',
      () async {
        // Arrange
        when(() => mockSettingsRepo.updateShippingConfig(tShippingConfigEntity))
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut(tShippingConfigEntity);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure.error, equals(tFailure.error));

        verify(
          () => mockSettingsRepo.updateShippingConfig(tShippingConfigEntity),
        ).called(1);
        verifyNoMoreInteractions(mockSettingsRepo);
      },
    );
  });
}
