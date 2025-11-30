import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/fruit_entity.dart';

abstract class ProductsRemoteDataSource {
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity);
  Future<NetworkResponse<List<FruitEntity>>> getAllProducts();
}
