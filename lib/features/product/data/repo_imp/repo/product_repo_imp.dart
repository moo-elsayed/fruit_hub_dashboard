import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';

import '../../../domain/entities/fruit_entity.dart';
import '../../../domain/repo_contarct/data_sources/remote/product_remote_data_source.dart';
import '../../../domain/repo_contarct/repo/product_repo.dart';

class ProductRepoImp implements ProductRepo {
  ProductRepoImp(this._addRemoteDataSource);

  final ProductRemoteDataSource _addRemoteDataSource;

  @override
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity) async =>
      await _addRemoteDataSource.addProduct(fruitEntity);
}
