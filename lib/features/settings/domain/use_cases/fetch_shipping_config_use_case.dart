import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import '../entities/shipping_config_entity.dart';
import '../settings_repo/settings_repo.dart';

class FetchShippingConfigUseCase {
  FetchShippingConfigUseCase(this._settingsRepo);

  final SettingsRepo _settingsRepo;

  Future<NetworkResponse<ShippingConfigEntity>> call() async =>
      await _settingsRepo.fetchShippingConfig();
}
