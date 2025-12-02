import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/settings_repo/settings_repo.dart';

class SettingsRepoImp implements SettingsRepo {
  SettingsRepoImp(this._settingsRemoteDataSource);

  final SettingsRemoteDataSource _settingsRemoteDataSource;

  @override
  Future<NetworkResponse<ShippingConfigEntity>> fetchShippingConfig() async =>
      _settingsRemoteDataSource.fetchShippingConfig();

  @override
  Future<NetworkResponse<void>> updateShippingConfig(
    ShippingConfigEntity shippingConfigEntity,
  ) async =>
      _settingsRemoteDataSource.updateShippingConfig(shippingConfigEntity);
}
