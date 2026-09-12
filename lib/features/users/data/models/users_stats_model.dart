import '../../domain/entities/users_stats_entity.dart';

class UsersStatsModel {
  const UsersStatsModel({
    this.totalCount = 0,
    this.verifiedCount = 0,
    this.activeCartCount = 0,
  });

  final int totalCount;
  final int verifiedCount;
  final int activeCartCount;

  UsersStatsEntity toEntity() => UsersStatsEntity(
    totalCount: totalCount,
    verifiedCount: verifiedCount,
    activeCartCount: activeCartCount,
  );
}
