import '../../domain/entities/cart_item_entity.dart';

class CartItemModel {
  const CartItemModel({required this.productId, required this.quantity});

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    productId:
        json['productId']?.toString() ??
        json['product_id']?.toString() ??
        json['code']?.toString() ??
        '',
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  );

  final String productId;
  final int quantity;

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
  };

  CartItemEntity toEntity() =>
      CartItemEntity(productId: productId, quantity: quantity);
}
