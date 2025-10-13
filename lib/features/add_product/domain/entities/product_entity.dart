class ProductEntity {
  ProductEntity({
    this.name = '',
    this.description = '',
    this.price = 0,
    this.isFeatured = false,
  });

  final String name;
  final String description;
  final double price;
  final bool isFeatured;
}
