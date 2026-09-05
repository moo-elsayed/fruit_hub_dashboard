import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../entities/fruit_entity.dart';
import '../repo/products_repo.dart';

class UpdateProductUseCase {
  UpdateProductUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Future<NetworkResponse<void>> call(FruitEntity fruitEntity) async =>
      await _productsRepo.updateProduct(fruitEntity);
}
