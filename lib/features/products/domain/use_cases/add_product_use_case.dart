import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';

class AddProductUseCase {
  AddProductUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Future<NetworkResponse<void>> call(FruitEntity fruitEntity) async =>
      await _productsRepo.addProduct(fruitEntity);
}
