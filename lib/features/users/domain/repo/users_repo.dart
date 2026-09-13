import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';

import '../../../../core/enums/user_filter_type.dart';
import '../../../../core/enums/user_search_by.dart';
import '../entities/dashboard_user_entity.dart';
import '../entities/notification_entity.dart';
import '../entities/send_notification_input_entity.dart';
import '../entities/users_page_entity.dart';
import '../entities/users_stats_entity.dart';

abstract class UsersRepo {
  Future<NetworkResponse<UsersPageEntity>> getUsers({
    int limit = 15,
    DocumentSnapshot? lastDocument,
    UserFilterType filter = UserFilterType.all,
  });
  Future<NetworkResponse<UsersStatsEntity>> getUsersStats();
  Future<NetworkResponse<List<DashboardUserEntity>>> searchUsers({
    required String query,
    required UserSearchBy searchBy,
    int limit = 30,
  });
  Future<NetworkResponse<List<NotificationEntity>>> getUserNotifications(
    String userId,
  );
  Future<NetworkResponse<NotificationEntity>> sendNotification(
    SendNotificationInputEntity input,
  );
}
