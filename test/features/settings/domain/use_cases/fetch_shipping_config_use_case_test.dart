import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_broadcast_notification_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/settings_repo/settings_repo.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/fetch_shipping_config_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepo extends Mock implements SettingsRepo {}

void main() {
  group('FetchShippingConfigUseCase', () {
    late MockSettingsRepo mockSettingsRepo;
    late FetchShippingConfigUseCase sut;

    const tFailure = ServerFailure(
      error: 'Failed to fetch shipping configuration',
    );

    const tNotificationEntity = ShippingBroadcastNotificationEntity(
      titleAr: 'شحن مجاني',
      titleEn: 'Free Shipping',
      bodyAr: 'للطلبات فوق 300 جنيه',
      bodyEn: 'For orders over 300 EGP',
      type: 'shipping',
      notify: true,
    );

    const tShippingConfigEntity = ShippingConfigEntity(
      shippingCost: 35.0,
      freeShippingThreshold: 250.0,
      broadcastNotification: tNotificationEntity,
    );

    setUp(() {
      mockSettingsRepo = MockSettingsRepo();
      sut = FetchShippingConfigUseCase(mockSettingsRepo);
    });

    test('should call fetchShippingConfig on SettingsRepo and return NetworkSuccess with ShippingConfigEntity on success', () async {
      // Arrange
      when(() => mockSettingsRepo.fetchShippingConfig())
          .thenAnswer((_) async => const NetworkSuccess(tShippingConfigEntity));

      // Act
      final result = await sut();

      // Assert
      expect(result, isA<NetworkSuccess<ShippingConfigEntity>>());
      final data = (result as NetworkSuccess<ShippingConfigEntity>).data;
      expect(data, equals(tShippingConfigEntity));

      verify(() => mockSettingsRepo.fetchShippingConfig()).called(1);
      verifyNoMoreInteractions(mockSettingsRepo);
    });

    test(
      'should return NetworkFailure when SettingsRepo returns NetworkFailure',
      () async {
        // Arrange
        when(() => mockSettingsRepo.fetchShippingConfig())
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut();

        // Assert
        expect(result, isA<NetworkFailure<ShippingConfigEntity>>());
        final failure =
            (result as NetworkFailure<ShippingConfigEntity>).failure;
        expect(failure.error, equals(tFailure.error));

        verify(() => mockSettingsRepo.fetchShippingConfig()).called(1);
        verifyNoMoreInteractions(mockSettingsRepo);
      },
    );
  });
}
