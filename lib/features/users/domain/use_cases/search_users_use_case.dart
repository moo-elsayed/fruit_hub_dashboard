import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../../../core/enums/user_search_by.dart';
import '../entities/dashboard_user_entity.dart';
import '../repo/users_repo.dart';

class SearchUsersUseCase {
  const SearchUsersUseCase(this._usersRepo);

  final UsersRepo _usersRepo;

  Future<NetworkResponse<List<DashboardUserEntity>>> call({
    required String query,
    required UserSearchBy searchBy,
    int limit = 30,
  }) => _usersRepo.searchUsers(query: query, searchBy: searchBy, limit: limit);
}
