import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/shipping_config_entity.dart';

abstract class SettingsRemoteDataSource {
  Future<NetworkResponse<ShippingConfigEntity>> fetchShippingConfig();

  Future<NetworkResponse<void>> updateShippingConfig(ShippingConfigEntity shippingConfigEntity);
}
