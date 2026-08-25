import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import '../entities/fruit_entity.dart';
import '../repo/products_repo.dart';

class GetProductsUseCase {
  GetProductsUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Future<NetworkResponse<List<FruitEntity>>> call() async =>
      await _productsRepo.getAllProducts();
}
