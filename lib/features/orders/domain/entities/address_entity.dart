import 'package:equatable/equatable.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';

class AddressEntity extends Equatable {
  const AddressEntity({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.city = '',
    this.streetName = '',
    this.buildingNumber = '',
    this.floorNumber = '',
    this.apartmentNumber = '',
  });

  final String name;
  final String email;
  final String phone;
  final String city;
  final String streetName;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;

  String get formattedLocation {
    final streetAndCity = [
      city,
      streetName,
    ].where((s) => s.trim().isNotEmpty).join('، ');

    final buildingParts = <String>[];
    if (buildingNumber.trim().isNotEmpty) {
      buildingParts.add('${AppStrings.building} $buildingNumber');
    }
    if (floorNumber.trim().isNotEmpty) {
      buildingParts.add('${AppStrings.floor} $floorNumber');
    }
    if (apartmentNumber.trim().isNotEmpty) {
      buildingParts.add('${AppStrings.apartment} $apartmentNumber');
    }
    final buildingDetails = buildingParts.join('، ');

    if (streetAndCity.isNotEmpty && buildingDetails.isNotEmpty) {
      return '$streetAndCity\n$buildingDetails';
    }
    return streetAndCity.isNotEmpty ? streetAndCity : buildingDetails;
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    city,
    streetName,
    buildingNumber,
    floorNumber,
    apartmentNumber,
  ];
}
