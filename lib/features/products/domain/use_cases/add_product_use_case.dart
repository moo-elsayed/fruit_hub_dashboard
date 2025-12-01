import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import '../entities/fruit_entity.dart';
import '../repo/products_repo.dart';

class AddProductUseCase {
  AddProductUseCase(this._repo);

  final ProductsRepo _repo;

  Future<NetworkResponse<void>> call(FruitEntity fruitEntity) async =>
      await _repo.addProduct(fruitEntity);
}
