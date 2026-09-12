import 'package:equatable/equatable.dart';

class UsersStatsEntity extends Equatable {
  const UsersStatsEntity({
    this.totalCount = 0,
    this.verifiedCount = 0,
    this.activeCartCount = 0,
  });

  final int totalCount;
  final int verifiedCount;
  final int activeCartCount;

  @override
  List<Object?> get props => [totalCount, verifiedCount, activeCartCount];
}
