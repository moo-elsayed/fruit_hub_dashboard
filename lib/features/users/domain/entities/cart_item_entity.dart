import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({required this.productId, this.quantity = 1});

  final String productId;
  final int quantity;

  CartItemEntity copyWith({String? productId, int? quantity}) => CartItemEntity(
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
  );

  @override
  List<Object?> get props => [productId, quantity];
}
