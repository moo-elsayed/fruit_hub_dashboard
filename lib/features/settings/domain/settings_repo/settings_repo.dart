import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';

abstract class SettingsRepo {
  Future<NetworkResponse<ShippingConfigEntity>> fetchShippingConfig();

  Future<NetworkResponse<void>> updateShippingConfig(ShippingConfigEntity shippingConfigEntity);
}
