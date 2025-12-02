import 'package:fruit_hub_dashboard/features/settings/domain/settings_repo/settings_repo.dart';
import '../../../../core/helpers/network_response.dart';
import '../entities/shipping_config_entity.dart';

class FetchShippingConfigUseCase {
  FetchShippingConfigUseCase(this._settingsRepo);

  final SettingsRepo _settingsRepo;

  Future<NetworkResponse<ShippingConfigEntity>> call() async =>
      _settingsRepo.fetchShippingConfig();
}
