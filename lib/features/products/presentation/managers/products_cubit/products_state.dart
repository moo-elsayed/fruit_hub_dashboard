part of 'products_cubit.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {
  ProductsLoading({
    this.itemRemoved = false,
    this.newItemAdded = false,
    this.itemUpdated = false,
  });

  final bool itemRemoved;
  final bool newItemAdded;
  final bool itemUpdated;
}

final class ProductsSuccess extends ProductsState {
  ProductsSuccess({
    required this.products,
    this.newItemAdded = false,
    this.itemRemoved = false,
    this.itemUpdated = false,
  });

  final List<FruitEntity> products;
  final bool newItemAdded;
  final bool itemRemoved;
  final bool itemUpdated;
}

final class ProductsFailure extends ProductsState {
  ProductsFailure(this.errorMessage);

  final String errorMessage;
}

// final class AddProductLoading extends ProductsState {}
//
// final class AddProductSuccess extends ProductsState {}
//
// final class AddProductFailure extends ProductsState {
//   AddProductFailure(this.errorMessage);
//
//   final String errorMessage;
// }
//
// final class GetProductsLoading extends ProductsState {}
//
// final class GetProductsSuccess extends ProductsState {
//   GetProductsSuccess(this.products);
//
//   final List<FruitEntity> products;
// }
//
// final class GetProductsFailure extends ProductsState {
//   GetProductsFailure(this.errorMessage);
//
//   final String errorMessage;
// }
