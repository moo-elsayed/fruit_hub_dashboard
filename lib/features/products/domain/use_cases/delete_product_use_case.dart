import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../repo/products_repo.dart';

class DeleteProductUseCase {
  DeleteProductUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Future<NetworkResponse<void>> call(String code) async =>
      await _productsRepo.deleteProduct(code);
}
