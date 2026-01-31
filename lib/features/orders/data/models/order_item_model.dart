import '../../domain/entities/order_item_entity.dart';

class OrderItemModel {
  OrderItemModel({
    required this.code,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> map) => OrderItemModel(
    code: map['code'] ?? '',
    name: map['name'] ?? '',
    imagePath: map['imageUrl'] ?? '',
    price: map['price'] ?? 0,
    quantity: map['quantity'] ?? 0,
  );

  final String code;
  final String name;
  final String imagePath;
  final double price;
  final int quantity;

  OrderItemEntity toEntity() => OrderItemEntity(
    code: code,
    name: name,
    imagePath: imagePath,
    price: price,
    quantity: quantity,
  );
}
