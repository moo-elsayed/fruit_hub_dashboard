import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/settings/data/models/shipping_broadcast_notification_model.dart';
import 'package:fruit_hub_dashboard/features/settings/data/models/shipping_config_model.dart';
import 'package:fruit_hub_dashboard/features/settings/data/repo_imp/settings_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_broadcast_notification_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(const ShippingConfigModel(shippingCost: 0.0));
  });

  group('SettingsRepoImp', () {
    late MockSettingsRemoteDataSource mockRemoteDataSource;
    late SettingsRepoImp sut;

    const tFailure = ServerFailure(error: 'Failed to fetch settings');

    const tNotificationModel = ShippingBroadcastNotificationModel(
      titleAr: 'شحن مجاني',
      titleEn: 'Free Shipping',
      bodyAr: 'للطلبات فوق 300 جنيه',
      bodyEn: 'For orders over 300 EGP',
      type: 'shipping',
      notify: true,
    );

    const tShippingConfigModel = ShippingConfigModel(
      shippingCost: 40.0,
      freeShippingThreshold: 300.0,
      broadcastNotification: tNotificationModel,
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
      shippingCost: 40.0,
      freeShippingThreshold: 300.0,
      broadcastNotification: tNotificationEntity,
    );

    setUp(() {
      mockRemoteDataSource = MockSettingsRemoteDataSource();
      sut = SettingsRepoImp(mockRemoteDataSource);
    });

    group('fetchShippingConfig', () {
      test('should return NetworkSuccess with mapped ShippingConfigEntity when remote data source returns NetworkSuccess with model', () async {
        // Arrange
        when(
          () => mockRemoteDataSource.fetchShippingConfig(),
        ).thenAnswer((_) async => const NetworkSuccess(tShippingConfigModel));

        // Act
        final result = await sut.fetchShippingConfig();

        // Assert
        expect(result, isA<NetworkSuccess<ShippingConfigEntity>>());
        final data = (result as NetworkSuccess<ShippingConfigEntity>).data;
        expect(data, isNotNull);
        expect(data!.shippingCost, 40.0);
        expect(data.freeShippingThreshold, 300.0);
        expect(data.broadcastNotification, isNotNull);
        expect(data.broadcastNotification!.titleAr, 'شحن مجاني');
        expect(data.broadcastNotification!.titleEn, 'Free Shipping');
        expect(data.broadcastNotification!.bodyAr, 'للطلبات فوق 300 جنيه');
        expect(data.broadcastNotification!.bodyEn, 'For orders over 300 EGP');
        expect(data.broadcastNotification!.type, 'shipping');
        expect(data.broadcastNotification!.notify, isTrue);

        verify(() => mockRemoteDataSource.fetchShippingConfig()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should return NetworkSuccess with fallback const ShippingConfigEntity() when remote data source returns NetworkSuccess with null data', () async {
        // Arrange
        when(() => mockRemoteDataSource.fetchShippingConfig())
            .thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut.fetchShippingConfig();

        // Assert
        expect(result, isA<NetworkSuccess<ShippingConfigEntity>>());
        final data = (result as NetworkSuccess<ShippingConfigEntity>).data;
        expect(data, isNotNull);
        expect(data!.shippingCost, 0.0);
        expect(data.freeShippingThreshold, 0.0);
        expect(data.broadcastNotification, isNull);

        verify(() => mockRemoteDataSource.fetchShippingConfig()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should return NetworkFailure when remote data source returns NetworkFailure', () async {
        // Arrange
        when(() => mockRemoteDataSource.fetchShippingConfig())
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.fetchShippingConfig();

        // Assert
        expect(result, isA<NetworkFailure<ShippingConfigEntity>>());
        final failure =
            (result as NetworkFailure<ShippingConfigEntity>).failure;
        expect(failure.error, tFailure.error);

        verify(() => mockRemoteDataSource.fetchShippingConfig()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
    });

    group('updateShippingConfig', () {
      test('should forward mapped ShippingConfigModel to remote data source and return NetworkSuccess(null) on success', () async {
        // Arrange
        when(() => mockRemoteDataSource.updateShippingConfig(any()))
            .thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut.updateShippingConfig(tShippingConfigEntity);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final captured =
            verify(
                  () => mockRemoteDataSource.updateShippingConfig(captureAny()),
                ).captured.single
                as ShippingConfigModel;

        expect(captured.shippingCost, tShippingConfigEntity.shippingCost);
        expect(
          captured.freeShippingThreshold,
          tShippingConfigEntity.freeShippingThreshold,
        );
        expect(captured.broadcastNotification, isNotNull);
        expect(
          captured.broadcastNotification!.titleAr,
          tNotificationEntity.titleAr,
        );
        expect(
          captured.broadcastNotification!.titleEn,
          tNotificationEntity.titleEn,
        );
        expect(
          captured.broadcastNotification!.bodyAr,
          tNotificationEntity.bodyAr,
        );
        expect(
          captured.broadcastNotification!.bodyEn,
          tNotificationEntity.bodyEn,
        );
        expect(captured.broadcastNotification!.type, tNotificationEntity.type);
        expect(
          captured.broadcastNotification!.notify,
          tNotificationEntity.notify,
        );

        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should forward model with null broadcastNotification when entity has null broadcastNotification', () async {
        // Arrange
        const entityWithoutNotification = ShippingConfigEntity(
          shippingCost: 25.0,
          freeShippingThreshold: 150.0,
          broadcastNotification: null,
        );

        when(() => mockRemoteDataSource.updateShippingConfig(any()))
            .thenAnswer((_) async => const NetworkSuccess(null));

        // Act
        final result = await sut.updateShippingConfig(
          entityWithoutNotification,
        );

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final captured =
            verify(
                  () => mockRemoteDataSource.updateShippingConfig(captureAny()),
                ).captured.single
                as ShippingConfigModel;

        expect(captured.shippingCost, 25.0);
        expect(captured.freeShippingThreshold, 150.0);
        expect(captured.broadcastNotification, isNull);

        verifyNoMoreInteractions(mockRemoteDataSource);
      });

      test('should return NetworkFailure when remote data source fails to update shipping config', () async {
        // Arrange
        when(() => mockRemoteDataSource.updateShippingConfig(any()))
            .thenAnswer((_) async => const NetworkFailure(tFailure));

        // Act
        final result = await sut.updateShippingConfig(tShippingConfigEntity);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure.error, tFailure.error);

        verify(() => mockRemoteDataSource.updateShippingConfig(any()))
            .called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      });
    });
  });
}
