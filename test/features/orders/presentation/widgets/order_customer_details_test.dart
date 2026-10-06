import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/address_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_customer_details.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrderCustomerDetails Widget Tests', () {
    const tAddress = AddressEntity(
      name: 'Mahmoud Hassan',
      phone: '01011122233',
      city: 'Giza',
      streetName: 'Dokki St',
      buildingNumber: '15',
      floorNumber: '3',
      apartmentNumber: '6',
    );

    testWidgets(
      'should render customer name, formatted location, phone, and shipping icon',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const OrderCustomerDetails(address: tAddress),
          ),
        );

        // Assert
        expect(find.text(AppStrings.shippingAddress), findsOneWidget);
        expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
        expect(find.text('Mahmoud Hassan'), findsOneWidget);
        expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
        expect(find.text(tAddress.formattedLocation), findsOneWidget);
        expect(find.text('01011122233'), findsOneWidget);
        expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
      },
    );

    testWidgets('should not render name row or phone row when they are empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      const emptyAddress = AddressEntity(
        name: '',
        phone: '',
        city: 'Cairo',
        streetName: 'Tahrir',
      );

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrderCustomerDetails(address: emptyAddress),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.person_outline_rounded), findsNothing);
      expect(find.byIcon(Icons.phone_outlined), findsNothing);
      expect(find.text(emptyAddress.formattedLocation), findsOneWidget);
    });
  });
}
