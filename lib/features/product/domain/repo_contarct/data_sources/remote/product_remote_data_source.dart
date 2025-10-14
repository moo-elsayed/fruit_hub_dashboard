import '../../../../../../core/helpers/network_response.dart';
import '../../../entities/fruit_entity.dart';

abstract class ProductRemoteDataSource {
  Future<NetworkResponse> addProduct(FruitEntity fruitEntity);
}
