part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class AddProductLoading extends ProductsState {}

final class AddProductSuccess extends ProductsState {}

final class AddProductFailure extends ProductsState {
  AddProductFailure(this.errorMessage);

  final String errorMessage;
}

final class GetProductsLoading extends ProductsState {}

final class GetProductsSuccess extends ProductsState {
  GetProductsSuccess(this.products);

  final List<FruitEntity> products;
}

final class GetProductsFailure extends ProductsState {
  GetProductsFailure(this.errorMessage);

  final String errorMessage;
}
