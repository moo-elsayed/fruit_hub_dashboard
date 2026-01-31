import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/functions.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/settings/data/repo_imp/settings_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

void main() {
  late SettingsRepoImp sut;
  late MockSettingsRemoteDataSource mockSettingsRemoteDataSource;

  const tShippingConfigEntity = ShippingConfigEntity(shippingCost: 50.0);
  const tShippingConfigEntityForUpdate = ShippingConfigEntity(
    shippingCost: 70.0,
  );

  const tSuccessResponseOfTypeShippingConfigEntity =
      NetworkSuccess<ShippingConfigEntity>(tShippingConfigEntity);
  final tFailureResponseOfTypeShippingConfigEntity =
      NetworkFailure<ShippingConfigEntity>(Exception('permission-denied'));

  const tSuccessResponseOfTypeVoid = NetworkSuccess<void>(null);
  final tFailureResponseOfTypeVoid = NetworkFailure<void>(
    FirebaseException(plugin: '', message: 'Permission denied'),
  );

  setUpAll(() {
    registerFallbackValue(const ShippingConfigEntity());
  });

  setUp(() {
    mockSettingsRemoteDataSource = MockSettingsRemoteDataSource();
    sut = SettingsRepoImp(mockSettingsRemoteDataSource);
  });

  group('SettingsRepoImp', () {
    group('fetchShippingConfig', () {
      test(
        'should return NetworkSuccess when fetchShippingConfig is successful',
        () async {
          // Arrange
          when(
            () => mockSettingsRemoteDataSource.fetchShippingConfig(),
          ).thenAnswer((_) async => tSuccessResponseOfTypeShippingConfigEntity);
          // Act
          final result = await sut.fetchShippingConfig();
          // Assert
          expect(result, tSuccessResponseOfTypeShippingConfigEntity);
          verify(
            () => mockSettingsRemoteDataSource.fetchShippingConfig(),
          ).called(1);
          verifyNoMoreInteractions(mockSettingsRemoteDataSource);
        },
      );

      test(
        'should return NetworkFailure when fetchShippingConfig throws an exception',
        () async {
          // Arrange
          when(
            () => mockSettingsRemoteDataSource.fetchShippingConfig(),
          ).thenAnswer((_) async => tFailureResponseOfTypeShippingConfigEntity);
          // Act
          final result = await sut.fetchShippingConfig();
          // Assert
          expect(result, tFailureResponseOfTypeShippingConfigEntity);
          verify(
            () => mockSettingsRemoteDataSource.fetchShippingConfig(),
          ).called(1);
          verifyNoMoreInteractions(mockSettingsRemoteDataSource);
        },
      );
    });
    group('updateShippingConfig', () {
      test(
        'should return NetworkSuccess when updateShippingConfig is successful',
        () async {
          // Arrange
          when(
            () => mockSettingsRemoteDataSource.updateShippingConfig(
              tShippingConfigEntityForUpdate,
            ),
          ).thenAnswer((_) async => tSuccessResponseOfTypeVoid);
          // Act
          final result = await sut.updateShippingConfig(
            tShippingConfigEntityForUpdate,
          );
          // Assert
          expect(result, tSuccessResponseOfTypeVoid);
          verify(
            () => mockSettingsRemoteDataSource.updateShippingConfig(any()),
          ).called(1);
          verifyNoMoreInteractions(mockSettingsRemoteDataSource);
        },
      );

      test(
        'should return NetworkFailure when updateShippingConfig throws an exception',
        () async {
          // Arrange
          when(
            () => mockSettingsRemoteDataSource.updateShippingConfig(
              tShippingConfigEntityForUpdate,
            ),
          ).thenAnswer((_) async => tFailureResponseOfTypeVoid);
          // Act
          final result = await sut.updateShippingConfig(
            tShippingConfigEntityForUpdate,
          );
          // Assert
          expect(result, tFailureResponseOfTypeVoid);
          expect(getErrorMessage(result), 'Permission denied');
          verify(
            () => mockSettingsRemoteDataSource.updateShippingConfig(any()),
          ).called(1);
          verifyNoMoreInteractions(mockSettingsRemoteDataSource);
        },
      );
    });
  });
}
