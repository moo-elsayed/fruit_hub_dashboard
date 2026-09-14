import '../../domain/entities/top_product_entity.dart';

class TopProductModel {
  const TopProductModel({
    required this.code,
    required this.name,
    required this.imagePath,
    required this.totalQuantitySold,
    required this.totalRevenue,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) =>
      TopProductModel(
        code: json['code'] as String? ?? '',
        name: json['name'] as String? ?? '',
        imagePath: json['imagePath'] as String? ?? '',
        totalQuantitySold: json['totalQuantitySold'] as int? ?? 0,
        totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      );

  factory TopProductModel.fromEntity(TopProductEntity entity) =>
      TopProductModel(
        code: entity.code,
        name: entity.name,
        imagePath: entity.imagePath,
        totalQuantitySold: entity.totalQuantitySold,
        totalRevenue: entity.totalRevenue,
      );

  final String code;
  final String name;
  final String imagePath;
  final int totalQuantitySold;
  final double totalRevenue;

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'imagePath': imagePath,
    'totalQuantitySold': totalQuantitySold,
    'totalRevenue': totalRevenue,
  };

  TopProductEntity toEntity() => TopProductEntity(
    code: code,
    name: name,
    imagePath: imagePath,
    totalQuantitySold: totalQuantitySold,
    totalRevenue: totalRevenue,
  );
}
