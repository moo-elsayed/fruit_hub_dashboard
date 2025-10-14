import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';

import '../../../../domain/entities/fruit_entity.dart';
import '../../../../domain/repo_contarct/data_sources/remote/product_remote_data_source.dart';

class ProductRemoteDataSourceImp implements ProductRemoteDataSource {
  @override
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity) {
    // TODO: implement addProduct
    throw UnimplementedError();
  }
}
