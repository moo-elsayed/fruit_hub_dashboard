import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/helpers/functions.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/database/database_service.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late SettingsRemoteDataSourceImp sut;
  late MockDatabaseService mockDatabaseService;

  final tShippingConfigMap = {'amount': 50.0};

  final tShippingConfigEntity = const ShippingConfigEntity(shippingCost: 50.0);

  final tShippingConfigEntityForUpdate = const ShippingConfigEntity(
    shippingCost: 70.0,
  );
  final tExpectedJson = {'amount': 70.0};

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    sut = SettingsRemoteDataSourceImp(mockDatabaseService);
  });

  group("SettingsRemoteDataSourceImp", () {
    group("fetchShippingConfig", () {
      test(
        'should return ShippingConfigEntity when database call is successful',
        () async {
          // Arrange
          when(
            () => mockDatabaseService.getData(
              path: BackendEndpoints.fetchShippingCost,
              documentId: BackendEndpoints.shippingConfigId,
            ),
          ).thenAnswer((_) async => tShippingConfigMap);

          // Act
          final result = await sut.fetchShippingConfig();
          // Assert
          expect(result, isA<NetworkSuccess<ShippingConfigEntity>>());
          expect(
            (result as NetworkSuccess<ShippingConfigEntity>).data!.shippingCost,
            tShippingConfigEntity.shippingCost,
          );
          verify(
            () => mockDatabaseService.getData(
              path: BackendEndpoints.fetchShippingCost,
              documentId: BackendEndpoints.shippingConfigId,
            ),
          ).called(1);
        },
      );

      test('should return NetworkFailure when database call fails', () async {
        // Arrange
        when(
          () => mockDatabaseService.getData(
            path: BackendEndpoints.fetchShippingCost,
            documentId: BackendEndpoints.shippingConfigId,
          ),
        ).thenThrow(Exception('Database Error'));

        // Act
        final result = await sut.fetchShippingConfig();

        // Assert
        expect(result, isA<NetworkFailure>());
        expect(getErrorMessage(result), 'Database Error');
        verify(
          () => mockDatabaseService.getData(
            path: BackendEndpoints.fetchShippingCost,
            documentId: BackendEndpoints.shippingConfigId,
          ),
        ).called(1);
      });
    });
    group("updateShippingConfig", () {
      test(
        'should return NetworkSuccess when database update is successful',
        () async {
          // Arrange
          when(
            () => mockDatabaseService.updateData(
              path: BackendEndpoints.updateShippingCost,
              documentId: BackendEndpoints.shippingConfigId,
              data: tExpectedJson,
            ),
          ).thenAnswer((_) async {});
          // Act
          final result = await sut.updateShippingConfig(
            tShippingConfigEntityForUpdate,
          );
          // Assert
          expect(result, isA<NetworkSuccess>());
          verify(
            () => mockDatabaseService.updateData(
              path: BackendEndpoints.updateShippingCost,
              documentId: BackendEndpoints.shippingConfigId,
              data: tExpectedJson,
            ),
          ).called(1);
        },
      );

      test('should return NetworkFailure when database update fails', () async {
        // Arrange
        when(
          () => mockDatabaseService.updateData(
            path: BackendEndpoints.updateShippingCost,
            documentId: BackendEndpoints.shippingConfigId,
            data: tExpectedJson,
          ),
        ).thenThrow(Exception('Database Error'));
        // Act
        final result = await sut.updateShippingConfig(
          tShippingConfigEntityForUpdate,
        );
        // Assert
        expect(result, isA<NetworkFailure>());
        expect(getErrorMessage(result), 'Database Error');
        verify(
          () => mockDatabaseService.updateData(
            path: BackendEndpoints.updateShippingCost,
            documentId: BackendEndpoints.shippingConfigId,
            data: tExpectedJson,
          ),
        ).called(1);
      });
    });
  });
}
