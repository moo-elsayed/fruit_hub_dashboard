import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import '../entities/fruit_entity.dart';

abstract class ProductsRepo {
  Future<NetworkResponse<List<FruitEntity>>> getAllProducts();

  Future<NetworkResponse<void>> addProduct(FruitEntity fruitEntity);

  Future<NetworkResponse<void>> deleteProduct(String code);

  Future<NetworkResponse<void>> updateProduct(FruitEntity fruitEntity);
}
