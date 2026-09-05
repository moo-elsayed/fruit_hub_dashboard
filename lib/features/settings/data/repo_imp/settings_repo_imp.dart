import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/data/models/shipping_config_model.dart';

import '../../domain/entities/shipping_config_entity.dart';
import '../../domain/settings_repo/settings_repo.dart';
import '../data_sources/remote/settings_remote_data_source.dart';

class SettingsRepoImp implements SettingsRepo {
  SettingsRepoImp(this._settingsRemoteDataSource);

  final SettingsRemoteDataSource _settingsRemoteDataSource;

  @override
  Future<NetworkResponse<ShippingConfigEntity>> fetchShippingConfig() async {
    final response = await _settingsRemoteDataSource.fetchShippingConfig();
    switch (response) {
      case NetworkSuccess<ShippingConfigModel>():
        return NetworkSuccess(
          response.data?.toEntity() ?? const ShippingConfigEntity(),
        );
      case NetworkFailure<ShippingConfigModel>():
        return NetworkFailure(response.failure);
    }
  }

  @override
  Future<NetworkResponse<void>> updateShippingConfig(
    ShippingConfigEntity shippingConfigEntity,
  ) async => await _settingsRemoteDataSource.updateShippingConfig(
    ShippingConfigModel.fromEntity(shippingConfigEntity),
  );
}
