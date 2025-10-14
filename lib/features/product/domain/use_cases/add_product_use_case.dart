import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import '../entities/fruit_entity.dart';
import '../repo_contarct/repo/product_repo.dart';

class AddProductUseCase {
  AddProductUseCase(this._repo);

  final ProductRepo _repo;

  Future<NetworkResponse> call(FruitEntity fruitEntity) async =>
      await _repo.addProduct(fruitEntity);
}
