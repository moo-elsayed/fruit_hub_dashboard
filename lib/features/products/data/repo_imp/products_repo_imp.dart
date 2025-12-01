import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import '../../domain/entities/fruit_entity.dart';
import '../../domain/repo/products_repo.dart';
import '../data_sources/remote/products_remote_data_source.dart';

class ProductsRepoImp implements ProductsRepo {
  ProductsRepoImp(this._productsRemoteDataSource);

  final ProductsRemoteDataSource _productsRemoteDataSource;

  @override
  Future<NetworkResponse<void>> addProduct(FruitEntity fruitEntity) async =>
      await _productsRemoteDataSource.addProduct(fruitEntity);

  @override
  Future<NetworkResponse<List<FruitEntity>>> getAllProducts() async =>
      await _productsRemoteDataSource.getAllProducts();

  @override
  Future<NetworkResponse<void>> deleteProduct(String code) async =>
      _productsRemoteDataSource.deleteProduct(code);

  @override
  Future<NetworkResponse<void>> updateProduct(FruitEntity fruitEntity) async =>
      _productsRemoteDataSource.updateProduct(fruitEntity);
}
