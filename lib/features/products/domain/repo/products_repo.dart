import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import '../entities/fruit_entity.dart';

abstract class ProductsRepo {
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity);
  Future<NetworkResponse<List<FruitEntity>>> getAllProducts();
}
