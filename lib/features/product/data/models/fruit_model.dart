import '../../domain/entities/fruit_entity.dart';

class FruitModel extends FruitEntity {
  FruitModel({
    super.name,
    super.description,
    super.price,
    super.imagePath,
    super.code,
    super.isFeatured,
  });

  factory FruitModel.fromJson(Map<String, dynamic> json) => FruitModel(
    name: json['name'],
    description: json['description'],
    price: json['price'],
    imagePath: json['imagePath'],
    code: json['code'],
    isFeatured: json['isFeatured'],
  );

  factory FruitModel.fromEntity(FruitEntity fruitEntity) => FruitModel(
    name: fruitEntity.name,
    description: fruitEntity.description,
    price: fruitEntity.price,
    imagePath: fruitEntity.imagePath,
    code: fruitEntity.code,
    isFeatured: fruitEntity.isFeatured,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'imagePath': imagePath,
    'code': code,
    'isFeatured': isFeatured,
  };
}
