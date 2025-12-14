class OrderItemEntity {
  OrderItemEntity({
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
}
