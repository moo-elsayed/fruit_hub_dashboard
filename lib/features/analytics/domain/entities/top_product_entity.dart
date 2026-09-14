import 'package:equatable/equatable.dart';

class TopProductEntity extends Equatable {
  const TopProductEntity({
    required this.code,
    required this.name,
    required this.imagePath,
    required this.totalQuantitySold,
    required this.totalRevenue,
  });

  final String code;
  final String name;
  final String imagePath;
  final int totalQuantitySold;
  final double totalRevenue;

  @override
  List<Object?> get props => [
    code,
    name,
    imagePath,
    totalQuantitySold,
    totalRevenue,
  ];
}
