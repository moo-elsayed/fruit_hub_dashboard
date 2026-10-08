import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/widgets/leaderboard_rank_badge.dart';

import '../../../../helpers/test_widget_wrapper.dart';

void main() {
  group('LeaderboardRankBadge Widget Tests', () {
    testWidgets('should render gold medal for rank 1', (tester) async {
      // Arrange
      const sut = LeaderboardRankBadge(rank: 1);

      // Act
      await tester.pumpWidget(createWidgetForTesting(child: sut));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('🥇'), findsOneWidget);
    });

    testWidgets('should render silver medal for rank 2', (tester) async {
      // Arrange
      const sut = LeaderboardRankBadge(rank: 2);

      // Act
      await tester.pumpWidget(createWidgetForTesting(child: sut));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('🥈'), findsOneWidget);
    });

    testWidgets('should render bronze medal for rank 3', (tester) async {
      // Arrange
      const sut = LeaderboardRankBadge(rank: 3);

      // Act
      await tester.pumpWidget(createWidgetForTesting(child: sut));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('🥉'), findsOneWidget);
    });

    testWidgets('should render circular number badge for rank 4 or higher', (
      tester,
    ) async {
      // Arrange
      const sut = LeaderboardRankBadge(rank: 4);

      // Act
      await tester.pumpWidget(createWidgetForTesting(child: sut));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('4'), findsOneWidget);
      expect(find.text('🥇'), findsNothing);
    });
  });
}
