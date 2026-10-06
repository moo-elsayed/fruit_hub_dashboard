import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_stats_header.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/widgets/orders_stats_header_skeleton.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('OrdersStatsHeaderSkeleton Widget Tests', () {
    testWidgets(
      'should render enabled Skeletonizer with OrdersStatsHeader child',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const OrdersStatsHeaderSkeleton()),
        );

        // Assert
        expect(
          find.byWidgetPredicate(
            (w) => w.runtimeType.toString() == '_Skeletonizer',
          ),
          findsOneWidget,
        );
        expect(find.byType(OrdersStatsHeader), findsOneWidget);
      },
    );
  });
}
