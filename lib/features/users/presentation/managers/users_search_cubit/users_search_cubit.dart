import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/enums/user_search_by.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../../domain/entities/dashboard_user_entity.dart';
import '../../../domain/use_cases/search_users_use_case.dart';

part 'users_search_state.dart';

class UsersSearchCubit extends Cubit<UsersSearchState> {
  UsersSearchCubit(this._searchUsersUseCase)
    : super(const UsersSearchInitial());

  final SearchUsersUseCase _searchUsersUseCase;

  String _currentQuery = '';
  UserSearchBy _currentSearchBy = UserSearchBy.name;

  UserSearchBy get currentSearchBy => _currentSearchBy;
  String get currentQuery => _currentQuery;

  Future<void> searchUsers(String query, {UserSearchBy? searchBy}) async {
    _currentQuery = query.trim();
    if (searchBy != null) _currentSearchBy = searchBy;

    if (_currentQuery.isEmpty) {
      emit(UsersSearchInitial(searchBy: _currentSearchBy));
      return;
    }

    if (_currentQuery.contains('@') && _currentSearchBy != UserSearchBy.email) {
      _currentSearchBy = UserSearchBy.email;
    } else if (RegExp(r'^\+?[0-9]{5,}$').hasMatch(_currentQuery) &&
        _currentSearchBy != UserSearchBy.phone) {
      _currentSearchBy = UserSearchBy.phone;
    }

    emit(UsersSearchLoading(searchBy: _currentSearchBy));

    final response = await _searchUsersUseCase(
      query: _currentQuery,
      searchBy: _currentSearchBy,
    );

    switch (response) {
      case NetworkSuccess(data: final users):
        emit(
          UsersSearchSuccess(
            users: users ?? [],
            query: _currentQuery,
            searchBy: _currentSearchBy,
          ),
        );
      case NetworkFailure(failure: final failure):
        emit(UsersSearchFailure(failure.error, searchBy: _currentSearchBy));
    }
  }

  void setSearchBy(UserSearchBy searchBy) {
    if (_currentSearchBy == searchBy) return;
    _currentSearchBy = searchBy;
    _currentQuery = '';
    emit(UsersSearchInitial(searchBy: searchBy));
  }

  void clearSearch() {
    _currentQuery = '';
    emit(UsersSearchInitial(searchBy: _currentSearchBy));
  }
}
