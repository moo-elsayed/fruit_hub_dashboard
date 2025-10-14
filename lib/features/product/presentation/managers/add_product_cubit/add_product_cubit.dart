import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/helpers/functions.dart';
import 'package:fruit_hub_dashboard/core/helpers/network_response.dart';
import 'package:fruit_hub_dashboard/features/product/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/product/domain/use_cases/add_product_use_case.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this._addProductUseCase) : super(AddProductInitial());

  final AddProductUseCase _addProductUseCase;

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
}
