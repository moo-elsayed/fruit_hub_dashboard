import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_stats_header.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/widgets/users_stats_header_skeleton.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('UsersStatsHeaderSkeleton Widget Tests', () {
    testWidgets(
      'should render enabled Skeletonizer with UsersStatsHeader child',
      (WidgetTester tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          createWidgetForTesting(child: const UsersStatsHeaderSkeleton()),
        );

        // Assert
        expect(
          find.byWidgetPredicate(
            (w) => w.runtimeType.toString() == '_Skeletonizer',
          ),
          findsOneWidget,
        );
        expect(find.byType(UsersStatsHeader), findsOneWidget);
      },
    );
  });
}
