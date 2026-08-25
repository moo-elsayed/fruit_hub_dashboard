import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import '../../models/shipping_config_model.dart';

abstract class SettingsRemoteDataSource {
  Future<NetworkResponse<ShippingConfigModel>> fetchShippingConfig();

  Future<NetworkResponse<void>> updateShippingConfig(
    ShippingConfigModel shippingConfigModel,
  );
}
