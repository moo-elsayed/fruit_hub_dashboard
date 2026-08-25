import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/errors/exceptions.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/api_helper.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/settings/data/models/shipping_config_model.dart';

class SettingsRemoteDataSourceImp implements SettingsRemoteDataSource {
  SettingsRemoteDataSourceImp({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<NetworkResponse<ShippingConfigModel>> fetchShippingConfig() async =>
      ApiHelper.executeSafely(() async {
        final docSnap = await _firestore
            .collection(BackendEndpoints.constantsCollection)
            .doc(BackendEndpoints.shippingConfigDocId)
            .get();
        if (!docSnap.exists || docSnap.data() == null) {
          throw BusinessException('Shipping configuration not found');
        }
        return ShippingConfigModel.fromJson(docSnap.data()!);
      }, functionName: 'fetchShippingConfig');

  @override
  Future<NetworkResponse<void>> updateShippingConfig(
    ShippingConfigModel shippingConfigModel,
  ) async => ApiHelper.executeSafely(() async {
    await _firestore
        .collection(BackendEndpoints.constantsCollection)
        .doc(BackendEndpoints.shippingConfigDocId)
        .set(shippingConfigModel.toJson(), SetOptions(merge: true));
  }, functionName: 'updateShippingConfig');
}
