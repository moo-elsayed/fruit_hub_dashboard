import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../../../core/enums/user_filter_type.dart';
import '../entities/users_page_entity.dart';
import '../repo/users_repo.dart';

class GetUsersUseCase {
  const GetUsersUseCase(this._usersRepo);

  final UsersRepo _usersRepo;

  Future<NetworkResponse<UsersPageEntity>> call({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    UserFilterType filter = UserFilterType.all,
  }) async => await _usersRepo.getUsers(
    limit: limit,
    lastDocument: lastDocument,
    filter: filter,
  );
}
