part of 'users_cubit.dart';

sealed class UsersState {
  const UsersState();
}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UsersSuccess extends UsersState {
  const UsersSuccess({
    required this.users,
    this.activeFilter = UserFilterType.all,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.totalCount = 0,
    this.verifiedCount = 0,
    this.activeCartCount = 0,
  });

  final List<DashboardUserEntity> users;
  final UserFilterType activeFilter;
  final bool hasMore;
  final bool isLoadingMore;
  final int totalCount;
  final int verifiedCount;
  final int activeCartCount;

  UsersSuccess copyWith({
    List<DashboardUserEntity>? users,
    UserFilterType? activeFilter,
    bool? hasMore,
    bool? isLoadingMore,
    int? totalCount,
    int? verifiedCount,
    int? activeCartCount,
  }) => UsersSuccess(
    users: users ?? this.users,
    activeFilter: activeFilter ?? this.activeFilter,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    totalCount: totalCount ?? this.totalCount,
    verifiedCount: verifiedCount ?? this.verifiedCount,
    activeCartCount: activeCartCount ?? this.activeCartCount,
  );
}

final class UsersFailure extends UsersState {
  const UsersFailure(this.message);

  final String message;
}
