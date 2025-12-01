import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/fruit_entity.dart';

abstract class ProductsRemoteDataSource {
  Future<NetworkResponse<List<FruitEntity>>> getAllProducts();

  Future<NetworkResponse<void>> addProduct(FruitEntity fruitEntity);

  Future<NetworkResponse<void>> deleteProduct(String code);

  Future<NetworkResponse<void>> updateProduct(FruitEntity fruitEntity);
}
