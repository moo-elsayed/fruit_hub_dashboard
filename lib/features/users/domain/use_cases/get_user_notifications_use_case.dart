import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../entities/notification_entity.dart';
import '../repo/users_repo.dart';

class GetUserNotificationsUseCase {
  GetUserNotificationsUseCase(this._usersRepo);

  final UsersRepo _usersRepo;

  Future<NetworkResponse<List<NotificationEntity>>> call(String userId) async =>
      await _usersRepo.getUserNotifications(userId);
}
