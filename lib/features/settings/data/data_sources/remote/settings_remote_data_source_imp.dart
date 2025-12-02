import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_logger.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/core/services/database/database_service.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source.dart';
import '../../../../../core/helpers/backend_endpoints.dart';
import '../../../../../core/helpers/failures.dart';
import '../../../domain/entities/shipping_config_entity.dart';
import '../../models/shipping_config_model.dart';

class SettingsRemoteDataSourceImp implements SettingsRemoteDataSource {
  SettingsRemoteDataSourceImp(this._databaseService);

  final DatabaseService _databaseService;

  @override
  Future<NetworkResponse<ShippingConfigEntity>> fetchShippingConfig() async {
    try {
      final response = await _databaseService.getData(
        path: BackendEndpoints.fetchShippingCost,
        documentId: BackendEndpoints.shippingConfigId,
      );
      var shippingConfigEntity = ShippingConfigModel.fromJson(
        response,
      ).toEntity();
      return NetworkSuccess(shippingConfigEntity);
    } on FirebaseException catch (e) {
      AppLogger.error(
        'error occurred in fetchShippingConfig',
        error: e.toString(),
      );
      return NetworkFailure(
        Exception(ServerFailure.fromFirebaseException(e).errorMessage),
      );
    } catch (e) {
      AppLogger.error(
        'error occurred in fetchShippingConfig',
        error: e.toString(),
      );
      return NetworkFailure(Exception(e.toString()));
    }
  }

  @override
  Future<NetworkResponse<void>> updateShippingConfig(
    ShippingConfigEntity shippingConfigEntity,
  ) async {
    try {
      var shippingConfigModel = ShippingConfigModel.fromEntity(
        shippingConfigEntity,
      );
      await _databaseService.updateData(
        path: BackendEndpoints.updateShippingCost,
        documentId: BackendEndpoints.shippingConfigId,
        data: shippingConfigModel.toJson(),
      );
      return const NetworkSuccess();
    } on FirebaseException catch (e) {
      AppLogger.error(
        'error occurred in updateShippingConfig',
        error: e.toString(),
      );
      return NetworkFailure(
        Exception(ServerFailure.fromFirebaseException(e).errorMessage),
      );
    } catch (e) {
      AppLogger.error(
        'error occurred in updateShippingConfig',
        error: e.toString(),
      );
      return NetworkFailure(Exception(e.toString()));
    }
  }
}
