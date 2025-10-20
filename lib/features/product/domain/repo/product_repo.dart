import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import '../entities/fruit_entity.dart';

abstract class ProductRepo {
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity);
}
