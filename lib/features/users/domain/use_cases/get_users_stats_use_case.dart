import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../entities/users_stats_entity.dart';
import '../repo/users_repo.dart';

class GetUsersStatsUseCase {
  const GetUsersStatsUseCase(this._usersRepo);

  final UsersRepo _usersRepo;

  Future<NetworkResponse<UsersStatsEntity>> call() =>
      _usersRepo.getUsersStats();
}
