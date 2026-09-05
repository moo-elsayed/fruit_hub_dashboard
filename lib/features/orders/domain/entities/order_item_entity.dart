import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  const OrderItemEntity({
    this.code = '',
    this.name = '',
    this.imagePath = '',
    this.price = 0,
    this.quantity = 0,
  });

  final String code;
  final String name;
  final String imagePath;
  final double price;
  final int quantity;

  @override
  List<Object?> get props => [code, name, imagePath, price, quantity];
}
