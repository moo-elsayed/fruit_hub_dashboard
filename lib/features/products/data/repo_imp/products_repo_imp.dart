import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import '../../domain/entities/fruit_entity.dart';
import '../../domain/repo/products_repo.dart';
import '../data_sources/remote/products_remote_data_source.dart';

class ProductsRepoImp implements ProductsRepo {
  ProductsRepoImp(this._addRemoteDataSource);

  final ProductsRemoteDataSource _addRemoteDataSource;

  @override
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity) async =>
      await _addRemoteDataSource.addProduct(fruitEntity);

  @override
  Future<NetworkResponse<List<FruitEntity>>> getAllProducts() async =>
      await _addRemoteDataSource.getAllProducts();
}
