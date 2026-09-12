part of 'users_search_cubit.dart';

sealed class UsersSearchState {
  const UsersSearchState({required this.searchBy});

  final UserSearchBy searchBy;
}

final class UsersSearchInitial extends UsersSearchState {
  const UsersSearchInitial({super.searchBy = UserSearchBy.name});
}

final class UsersSearchLoading extends UsersSearchState {
  const UsersSearchLoading({required super.searchBy});
}

final class UsersSearchSuccess extends UsersSearchState {
  const UsersSearchSuccess({
    required this.users,
    required this.query,
    required super.searchBy,
  });

  final List<DashboardUserEntity> users;
  final String query;
}

final class UsersSearchFailure extends UsersSearchState {
  const UsersSearchFailure(this.message, {required super.searchBy});

  final String message;
}
