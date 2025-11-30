import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/add_product_use_case.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/fruit_entity.dart';
import '../../../domain/use_cases/get_products_use_case.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._addProductUseCase, this._getAllProductsUseCase)
    : super(ProductsInitial());

  final AddProductUseCase _addProductUseCase;
  final GetProductsUseCase _getAllProductsUseCase;

  Future<void> addProduct(FruitEntity fruit) async {
    emit(AddProductLoading());
    var networkResponse = await _addProductUseCase.call(fruit);
    switch (networkResponse) {
      case NetworkSuccess():
        emit(AddProductSuccess());
      case NetworkFailure():
        emit(AddProductFailure(getErrorMessage(networkResponse)));
    }
  }

  Future<void> getProducts() async {
    emit(GetProductsLoading());
    var networkResponse = await _getAllProductsUseCase.call();
    switch (networkResponse) {
      case NetworkSuccess<List<FruitEntity>>():
        emit(GetProductsSuccess(networkResponse.data!));
      case NetworkFailure<List<FruitEntity>>():
        emit(GetProductsFailure(getErrorMessage(networkResponse)));
    }
  }
}
