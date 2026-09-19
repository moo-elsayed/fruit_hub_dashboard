import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../../../../core/enums/user_filter_type.dart';
import '../../../domain/entities/dashboard_user_entity.dart';
import '../../../domain/entities/users_stats_entity.dart';
import '../../../domain/use_cases/get_users_stats_use_case.dart';
import '../../../domain/use_cases/get_users_use_case.dart';

export '../../../../../core/enums/user_filter_type.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._getUsersUseCase, this._getUsersStatsUseCase)
    : super(UsersInitial());

  final GetUsersUseCase _getUsersUseCase;
  final GetUsersStatsUseCase _getUsersStatsUseCase;

  static const int _pageSize = 15;
  List<DashboardUserEntity> _users = [];
  UserFilterType _activeFilter = UserFilterType.all;

  DocumentSnapshot? _lastDocument;
  bool _hasMore = false;
  bool _isLoadingMore = false;
  int _totalCount = 0;
  int _verifiedCount = 0;
  int _activeCartCount = 0;

  int get totalCount => _totalCount;
  int get verifiedCount => _verifiedCount;
  int get activeCartCount => _activeCartCount;
  UserFilterType get activeFilter => _activeFilter;

  Future<void> initUsers() async {
    await Future.wait([getUsersStats(), getUsers()]);
  }

  Future<void> getUsersStats() async {
    final response = await _getUsersStatsUseCase();
    if (response is NetworkSuccess<UsersStatsEntity>) {
      final stats = response.data;
      if (stats != null) {
        _totalCount = stats.totalCount;
        _verifiedCount = stats.verifiedCount;
        _activeCartCount = stats.activeCartCount;
        if (state is UsersSuccess) {
          emit(
            (state as UsersSuccess).copyWith(
              totalCount: _totalCount,
              verifiedCount: _verifiedCount,
              activeCartCount: _activeCartCount,
            ),
          );
        }
      }
    }
  }

  Future<void> getUsers({UserFilterType? filter}) async {
    if (filter != null) {
      _activeFilter = filter;
    }
    _lastDocument = null;
    _hasMore = false;
    _isLoadingMore = false;
    emit(UsersLoading());

    final response = await _getUsersUseCase(
      limit: _pageSize,
      filter: _activeFilter,
    );
    switch (response) {
      case NetworkSuccess(data: final page):
        if (page != null) {
          _users = List.of(page.users);
          _hasMore = page.hasMore;
          _lastDocument = page.lastDocument;
        } else {
          _users = [];
          _hasMore = false;
        }
        _emitSuccess();
      case NetworkFailure(failure: final failure):
        emit(UsersFailure(failure.error));
    }
  }

  Future<void> loadMoreUsers() async {
    if (_isLoadingMore || !_hasMore || state is! UsersSuccess) return;

    _isLoadingMore = true;
    final currentState = state as UsersSuccess;
    emit(currentState.copyWith(isLoadingMore: true));

    final response = await _getUsersUseCase(
      limit: _pageSize,
      lastDocument: _lastDocument,
      filter: _activeFilter,
    );

    switch (response) {
      case NetworkSuccess(data: final page):
        _isLoadingMore = false;
        if (page != null && page.users.isNotEmpty) {
          _users.addAll(page.users);
          _hasMore = page.hasMore;
          _lastDocument = page.lastDocument;
        } else {
          _hasMore = false;
        }
        _emitSuccess();
      case NetworkFailure():
        _isLoadingMore = false;
        emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  Future<void> setFilter(UserFilterType filter) async {
    if (_activeFilter == filter && state is UsersSuccess) return;
    _activeFilter = filter;
    await getUsers();
  }

  void _emitSuccess() => emit(
    UsersSuccess(
      users: List.unmodifiable(_users),
      activeFilter: _activeFilter,
      hasMore: _hasMore,
      isLoadingMore: _isLoadingMore,
      totalCount: _totalCount,
      verifiedCount: _verifiedCount,
      activeCartCount: _activeCartCount,
    ),
  );
}
