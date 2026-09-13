import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../entities/notification_entity.dart';
import '../entities/send_notification_input_entity.dart';
import '../repo/users_repo.dart';

class SendUserNotificationUseCase {
  SendUserNotificationUseCase(this._usersRepo);

  final UsersRepo _usersRepo;

  Future<NetworkResponse<NotificationEntity>> call(
    SendNotificationInputEntity input,
  ) async => await _usersRepo.sendNotification(input);
}
