import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_count_badge.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_network_image.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_price_text.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/order_item_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/order_product_card.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrderProductCard Widget Tests', () {
    const tProduct = OrderItemEntity(
      name: 'Fresh Mango',
      code: 'MNG10',
      price: 60.0,
      quantity: 3,
      imagePath: 'https://example.com/mango.png',
    );

    testWidgets(
      'should render product details, network image, code, total price, and quantity badge',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(
            child: const OrderProductCard(product: tProduct),
          ),
        );

        // Assert
        expect(find.text('Fresh Mango'), findsOneWidget);
        expect(find.text('${AppStrings.codeLabel}MNG10'), findsOneWidget);
        expect(find.byType(CustomNetworkImage), findsOneWidget);

        // Total price for item = 60 * 3 = 180.0
        expect(
          find.byWidgetPredicate(
            (w) => w is CustomPriceText && w.price == 180.0,
          ),
          findsOneWidget,
        );

        // Quantity badge = x3
        expect(
          find.byWidgetPredicate(
            (w) => w is CustomCountBadge && w.text == 'x3',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('should not render code row when code is empty', (
      WidgetTester tester,
    ) async {
      // Arrange
      const productWithoutCode = OrderItemEntity(
        name: 'Strawberries',
        code: '',
        price: 40.0,
        quantity: 1,
      );

      // Act
      await tester.pumpWidget(
        createWidgetForTesting(
          child: const OrderProductCard(product: productWithoutCode),
        ),
      );

      // Assert
      expect(find.text('Strawberries'), findsOneWidget);
      expect(find.textContaining(AppStrings.codeLabel), findsNothing);
    });
  });
}
