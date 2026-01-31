import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/add_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/update_product_use_case.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/helpers/network_response.dart';
import '../../../domain/entities/fruit_entity.dart';
import '../../../domain/use_cases/get_products_use_case.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(
    this._addProductUseCase,
    this._getAllProductsUseCase,
    this._deleteProductUseCase,
    this._updateProductUseCase,
  ) : super(ProductsInitial());

  final GetProductsUseCase _getAllProductsUseCase;
  final AddProductUseCase _addProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;

  List<FruitEntity> _fruits = [];

  Future<void> addProduct(FruitEntity fruit) async {
    emit(ProductsLoading(newItemAdded: true));
    final networkResponse = await _addProductUseCase.call(fruit);
    switch (networkResponse) {
      case NetworkSuccess():
        await getProducts(newItemAdded: true, needLoading: false);
      case NetworkFailure():
        emit(ProductsFailure(getErrorMessage(networkResponse)));
    }
  }

  Future<void> getProducts({
    bool needLoading = true,
    bool newItemAdded = false,
    bool itemRemoved = false,
    bool itemUpdated = false,
  }) async {
    if (needLoading) {
      emit(ProductsLoading());
    }
    final networkResponse = await _getAllProductsUseCase.call();
    switch (networkResponse) {
      case NetworkSuccess<List<FruitEntity>>():
        _fruits = networkResponse.data!;
        _emitSuccess(newItemAdded, itemRemoved, itemUpdated);
      case NetworkFailure<List<FruitEntity>>():
        emit(ProductsFailure(getErrorMessage(networkResponse)));
    }
  }

  Future<void> deleteProduct(String code) async {
    emit(ProductsLoading(itemRemoved: true));
    final networkResponse = await _deleteProductUseCase.call(code);
    switch (networkResponse) {
      case NetworkSuccess():
        await getProducts(itemRemoved: true, needLoading: false);
      case NetworkFailure():
        emit(ProductsFailure(getErrorMessage(networkResponse)));
    }
  }

  Future<void> updateProduct(FruitEntity fruit) async {
    emit(ProductsLoading(itemUpdated: true));
    final networkResponse = await _updateProductUseCase.call(fruit);
    switch (networkResponse) {
      case NetworkSuccess():
        await getProducts(itemUpdated: true, needLoading: false);
      case NetworkFailure():
        emit(ProductsFailure(getErrorMessage(networkResponse)));
    }
  }

  // -------------------------------------------------------------------
  // Private Helper Methods
  // -------------------------------------------------------------------
  void _emitSuccess(bool newItemAdded, bool itemRemoved, bool itemUpdated) =>
      emit(
        ProductsSuccess(
          products: _fruits,
          newItemAdded: newItemAdded,
          itemRemoved: itemRemoved,
          itemUpdated: itemUpdated,
        ),
      );
}
